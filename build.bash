# Build the ebook. Check build.md to prep build environment.

# Check arg.
case $1 in
    epub) echo "Building $1" ;;
    pdf) echo "Building $1" ;;
    *) echo "Usage: $0 [epub|pdf]" > /dev/stderr && exit 1
esac

# Pre-process foreward template version.
if [[ -n $(git status -s) ]]; then
    COMMIT="#######"
    EPOCH=$(date +%s)
else
    COMMIT=$(git log -1 --format=%h)
    EPOCH=$(git log -1 --format=%ct)
    TAG=$(git describe --tags --candidates=0 $COMMIT 2>/dev/null)
    if [[ -n $TAG ]]; then
        COMMIT=$TAG
    fi
fi
DATE="@$EPOCH"
VERSION="Commit $COMMIT, $(date -d $DATE +'%B %d, %Y')."
sed "s/{{ version }}/$VERSION/g" foreward.tpl.md > foreward.md
echo "${VERSION}"

# Pre-process input files.
MD="HanFeiziLaozi-$COMMIT.md"
sed -s '$G' -s \
    foreward.md \
    jie-lao-01.md \
    jie-lao-02.md \
    jie-lao-03.md \
    jie-lao-04.md \
    jie-lao-05.md \
    jie-lao-06.md \
    jie-lao-07.md \
    jie-lao-08.md \
    jie-lao-09.md \
    jie-lao-10.md \
    jie-lao-11.md \
    yu-lao-01.md \
    yu-lao-02.md \
    yu-lao-03.md \
    yu-lao-04.md \
    yu-lao-05.md \
    yu-lao-06.md \
    yu-lao-07.md \
    yu-lao-08.md \
    yu-lao-09.md \
    yu-lao-10.md \
    yu-lao-11.md \
    yu-lao-12.md \
    shiji.md \
    README.md > "$MD"

# Build epub.
if [ $1 = "epub" ]; then
    EPUB="HanFeiziLaozi-$COMMIT.epub"
    CJK_FONT="/usr/share/fonts/opentype/noto/NotoSerifCJK-Light.ttc"
    CJK_OUT="epub-fonts/CJK.ttf"
    python epub_fonts.py "$MD" "$CJK_FONT" "$CJK_OUT" cjk
    pandoc "$MD" \
        --defaults epub-defaults.yaml \
        --output "${EPUB}"
    echo Built "${EPUB}"
fi

## Or build pdf.
if [ $1 = "pdf" ]; then
    PDF="HanFeiziLaozi-$COMMIT.pdf"
    pandoc "$MD" \
        --defaults pdf-defaults.yaml \
        --output "${PDF}"
    echo Built "${PDF}"
fi
