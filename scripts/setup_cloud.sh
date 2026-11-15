#!/usr/bin/env bash
# Tested non-root Debian 13 bootstrap. No credentials or TLS/signature bypass.
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
tools_dir="${OPENBE_TOOLCHAIN:-/workspace/toolchain}"
mkdir -p "$tools_dir"/{apt/lists/partial,apt/archives/partial,root,bin,R-library,cache,renv,sources}
export XDG_CACHE_HOME="$tools_dir/cache"
export RENV_PATHS_ROOT="$tools_dir/renv"
export PATH="$tools_dir/bin:$PATH"
if ! command -v R >/dev/null; then
  test -f /usr/share/keyrings/debian-archive-keyring.pgp
  cat > "$tools_dir/apt/sources.list" <<'SOURCES'
deb [signed-by=/usr/share/keyrings/debian-archive-keyring.pgp] https://deb.debian.org/debian trixie main
SOURCES
  cat > "$tools_dir/apt/apt.conf" <<APT
Dir::Etc::sourcelist "$tools_dir/apt/sources.list";
Dir::Etc::sourceparts "-";
Dir::State::lists "$tools_dir/apt/lists";
Dir::State::status "$tools_dir/apt/status";
Dir::Cache::archives "$tools_dir/apt/archives";
Debug::NoLocking "true";
APT::Sandbox::User "$(id -un)";
APT
  touch "$tools_dir/apt/status"
  /usr/bin/apt-get -c "$tools_dir/apt/apt.conf" update
  /usr/bin/apt-get -c "$tools_dir/apt/apt.conf" --download-only -y --no-install-recommends install \
    r-base-core r-base-dev r-cran-testthat r-cran-ggplot2 r-cran-dplyr r-cran-tidyr \
    r-cran-readr r-cran-readxl r-cran-nlme r-cran-lme4 r-cran-lmertest r-cran-emmeans \
    r-cran-knitr r-cran-rmarkdown r-cran-roxygen2 r-cran-pkgdown r-cran-cubature \
    r-cran-mvtnorm r-cran-pbkrtest r-cran-checkmate r-cran-remotes \
    r-cran-r.oo r-cran-r.methodss3 r-cran-rstudioapi
  for archive in "$tools_dir"/apt/archives/*.deb; do dpkg-deb -x "$archive" "$tools_dir/root"; done
  # Debian normally generates this in its root-level postinstall.
  cp "$tools_dir/root/usr/lib/R/etc/Renviron.ucf" "$tools_dir/root/etc/R/Renviron"
  python3 - "$tools_dir" <<'PY'
from pathlib import Path
import sys
root=Path(sys.argv[1])
for p in (root/'root/usr/lib/R/etc').iterdir():
    if p.is_symlink() and str(p.readlink()).startswith('/etc/R/'):
        target=root/'root'/str(p.readlink()).lstrip('/')
        p.unlink();p.symlink_to(target)
p=root/'root/usr/lib/R/bin/R'
p.write_text(p.read_text().replace('/usr/lib/R',str(root/'root/usr/lib/R')).replace('/usr/share/R',str(root/'root/usr/share/R')))
PY
  cat > "$tools_dir/bin/R" <<RWRAP
#!/bin/sh
export R_HOME="$tools_dir/root/usr/lib/R"
export R_SHARE_DIR="$tools_dir/root/usr/share/R/share"
export R_INCLUDE_DIR="$tools_dir/root/usr/share/R/include"
export R_DOC_DIR="$tools_dir/root/usr/share/doc/r-base-core"
export R_LIBS_SITE="$tools_dir/root/usr/lib/R/site-library"
export R_LIBS_USER="$tools_dir/R-library"
export LD_LIBRARY_PATH="$tools_dir/root/usr/lib/R/lib:$tools_dir/root/usr/lib/x86_64-linux-gnu\${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"
exec "$tools_dir/root/usr/lib/R/bin/R" "\$@"
RWRAP
  cat > "$tools_dir/bin/Rscript" <<RSWRAP
#!/bin/bash
if [[ "\$1" == "-e" || "\$1" == "--version" ]]; then
  exec "$tools_dir/bin/R" --no-echo --no-restore "\$@"
fi
exec "$tools_dir/bin/R" --no-echo --no-restore --file="\$1" --args "\${@:2}"
RSWRAP
  chmod +x "$tools_dir/bin/R" "$tools_dir/bin/Rscript"
  ln -sf "$tools_dir/bin/Rscript" "$tools_dir/root/usr/lib/R/bin/Rscript"
fi
if ! command -v quarto >/dev/null; then
  curl -fL --retry 2 https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.27/quarto-1.8.27-linux-amd64.tar.gz -o "$tools_dir/quarto.tar.gz"
  curl -fL --retry 2 https://github.com/quarto-dev/quarto-cli/releases/download/v1.8.27/quarto-1.8.27-checksums.txt -o "$tools_dir/quarto-checksums.txt"
  python3 - "$tools_dir" <<'PY'
from pathlib import Path
import hashlib,sys,tarfile
p=Path(sys.argv[1]);name='quarto-1.8.27-linux-amd64.tar.gz'
expected=[x.split()[0] for x in (p/'quarto-checksums.txt').read_text().splitlines() if name in x][0]
assert hashlib.sha256((p/'quarto.tar.gz').read_bytes()).hexdigest()==expected,'Quarto checksum mismatch'
with tarfile.open(p/'quarto.tar.gz') as t:t.extractall(p,filter='data')
PY
  ln -sf "$tools_dir/quarto-1.8.27/bin/quarto" "$tools_dir/bin/quarto"
fi
# CRAN GitHub mirrors are an explicitly documented fallback where CRAN is blocked.
# Every non-Debian source is checked out at its audited immutable commit.
python3 - "$project_dir" "$tools_dir" <<'PY'
from pathlib import Path
import json,subprocess,sys
project=Path(sys.argv[1]);toolchain=Path(sys.argv[2])
for item in json.loads((project/'inst/extdata/source-pins.json').read_text()):
    package=item['package']
    code=f'quit(status=if(requireNamespace("{package}",quietly=TRUE) && as.character(packageVersion("{package}"))=="{item["version"]}") 0 else 1)'
    if subprocess.run(['Rscript','-e',code]).returncode==0:continue
    dest=toolchain/'sources'/package
    if not dest.exists():subprocess.run(['git','clone',item['repository'],str(dest)],check=True)
    subprocess.run(['git','-C',str(dest),'checkout','--detach',item['commit']],check=True)
    observed=subprocess.check_output(['git','-C',str(dest),'rev-parse','HEAD'],text=True).strip()
    assert observed==item['commit']
    subprocess.run(['R','CMD','INSTALL','--library='+str(toolchain/'R-library'),str(dest)],check=True)
PY
cd "$project_dir"
R CMD INSTALL .
Rscript -e 'library(OpenBE); stopifnot(is.finite(analyze_2x2(example_dataset(1))$summary$gmr))'
quarto --version
