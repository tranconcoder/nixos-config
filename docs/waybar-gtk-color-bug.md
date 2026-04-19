# Waybar GTK Invalid Color Bug

## Lỗi

```
[error] gtk.css:9:28 '' is not a valid color name
```

Waybar không hiển thị đúng màu, log báo color không hợp lệ trong `gtk.css`.

## Nguyên nhân

File `~/.cache/hyde/dcols/53a79e21e526c7f809747304679db1e23fd35743.dcol` (và symlink `wall.dcol` trỏ tới nó) có **tất cả color values rỗng**:

```
dcol_pry1=""
dcol_pry1_rgba=""
dcol_txt1=""
```

Script `color.set.sh` dùng sed thay `<wallbash_pry1>` bằng giá trị rỗng → `gtk.css` sinh ra:

```css
@define-color wallbash_pry1 #;
```

GTK báo lỗi vì `#` không phải color hợp lệ.

### Root cause

Service `hyde-config` chạy `color.set.sh` lúc boot nhưng bị **race condition** - wallpaper chưa sẵn sàng nên `magick` (ImageMagick) extract colors thất bại, tạo `.dcol` files rỗng. Test chạy thủ công `wallbash.sh` thì **hoạt động đúng**, sinh colors như `dcol_pry1="1A1321"`.

## Phân tích declarative issue

Service `hyde-config` hiện tại chỉ có `After=graphical-session.target`, không depend vào wallpaper service:

```
After=graphical-session.target basic.target app.slice -.mount
```

Trong khi `hyde-Hyprland-wallpaper` là transient service chạy async. → Race condition: `hyde-config` extract colors trước khi wallpaper sẵn sàng.

## Hướng fix declarative

Override `After` của `hyde-config` service để thêm dependency vào wallpaper service, thay vì tạo service mới gọi script imperatively:

```nix
systemd.user.services.hyde-config = {
  After = lib.mkAfter [ "hyde-Hyprland-wallpaper.service" ];
};
```

Hoặc nếu hydenix module hỗ trợ option cấu hình ordering, dùng option đó.

## Kết quả test thủ công

Chạy `color.set.sh` thủ công với `$HOME/.local/bin` trong `PATH` → sinh colors đúng, waybar hiển thị bình thường.