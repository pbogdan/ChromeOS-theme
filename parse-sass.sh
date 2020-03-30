#!/usr/bin/env bash
set -ueo pipefail

if [[ ! "$(command -v sassc)" ]]; then
  echo "'sassc' needs to be installed to generate the CSS."
  exit 1
fi

SASSC_OPT=('-p' '5' '-M' '-t' 'expanded')

_COLOR_VARIANTS=('' '-dark' '-light')
_BCOLOR_VARIANTS=('' '-dark')
_SIZE_VARIANTS=('' '-compact')

if [[ -n "${COLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _COLOR_VARIANTS <<< "${COLOR_VARIANTS:-}"
fi

if [[ -n "${BCOLOR_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _BCOLOR_VARIANTS <<< "${BCOLOR_VARIANTS:-}"
fi

if [[ -n "${SIZE_VARIANTS:-}" ]]; then
  IFS=', ' read -r -a _SIZE_VARIANTS <<< "${SIZE_VARIANTS:-}"
fi

echo "== Generating the CSS..."

for color in "${_COLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    sassc "${SASSC_OPT[@]}" "src/gtk/3.0/gtk$color$size."{scss,css}
  done
done

for color in "${_BCOLOR_VARIANTS[@]}"; do
  for size in "${_SIZE_VARIANTS[@]}"; do
    sassc "${SASSC_OPT[@]}" "src/gnome-shell/gnome-shell$color$size."{scss,css}
  done
done
