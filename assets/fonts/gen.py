import sys

def chr_page(c): return ord(c) // 256
def chr_x16(c): return ord(c) % 16
def chr_y16(c): return (ord(c) // 16) % 16
def chr_x(c): return chr_x16(c) * 16
def chr_y(c): return chr_y16(c) * 16

def to_page_def(s):
    i, f = s.split('|')
    return (int(i), f)

def transform(path_in, path_out):
    file = open(path_in, "r", encoding="utf8")
    lines = file.readlines()
    file.close()

    name, spacing_str = lines[0].split()
    spacing = int(spacing_str)

    pages = list(map(to_page_def, lines[1].split()))
    page_ids = {}
    for i in range(len(pages)):
        page_ids[pages[i][0]] = i

    vals = []

    for line in lines[2:]:
        l = line.strip()
        if len(l) < 4:
            continue
        character = l[1]
        values = l[3:].strip().split()
        advance = 0
        back = 0
        match len(values):
            case 0:
                continue
            case 1:
                advance = int(values[0])
            case _:
                advance = int(values[0])
                back = int(values[1])
        vals.append((character, advance, back))

    out_lines = []
    out_lines.append(" ".join([
        "info",
        f"face=\"{name}\"",
        "size=16",
        "bold=0",
        "italic=0",
        "charset=\"\"",
        "unicode=1",
        "stretchH=100",
        "smooth=0",
        "aa=1",
        "padding=0,0,0,0",
        "spacing=0,0"
    ]))
    out_lines.append(" ".join([
        "common",
        "lineHeight=16",
        "base=10",
        "scaleW=256",
        "scaleH=256",
        f"pages={len(pages)}",
        "packed=0"
    ]))

    for i, f in pages:
        out_lines.append(f"page id={page_ids[i]} file=\"{f}\"")

    out_lines.append(f"chars count={len(vals)}")

    for c, a, b in vals:
        out_lines.append(" ".join([
            "char",
            f"id={ord(c)}",
            f"x={chr_x(c)}",
            f"y={chr_y(c)}",
            f"width={a}",
            "height=16",
            f"xoffset={b}",
            "yoffset=0",
            f"xadvance={a + b + spacing}",
            f"page={page_ids[chr_page(c)]}",
            "chnl=15"
        ]))
    
    out_lines.append("kernings count=0")

    out_lines.append("")

    out = open(path_out, "w", encoding="utf8", newline='\n')
    out.writelines("\n".join(out_lines))
    out.close()

if __name__ == "__main__":
    transform("assets/fonts/big.txt", "godot/assets/fonts/big.fnt")
    transform("assets/fonts/reg.txt", "godot/assets/fonts/reg.fnt")
    transform("assets/fonts/spe.txt", "godot/assets/fonts/spe.fnt")
