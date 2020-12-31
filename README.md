Tiến độ hiện tại:
- xong UI
- WIP các chức năng:
   + chức năng challenge cần hoàn thành nốt logic countdown 24h sau khi làm xong 1 thử thách
   + chức năng show list các tương quan đã load lên, còn bug ui ở trang detail
   + chức năng show hũ đậu (đang bug)
- Chức năng cần làm (chưa start):
   + add đậu
   + get list trăn trở
- Chức năng cho giai đoạn sau:
   + Chức năng đặt mục tiêu
   + Badge (biểu hiệu)
   + Lời nhắc
# Beans

1/ Chức năng của trang home:
_Thử thách 24h

TT 1: home gồm có 3 tương quan ở trên và thử thách 24 giờ bên dưới. randomly generate 1 thử thách bất kì khi bật app lên , button chấp nhận thử thách which dẫn người dùng sang TT 2


TT 2: home với 3 tương quan phía trên, bên dưới là thử thách 24 giờ, sau khi user nhấn 'chấp nhận thử thách' --> button trở thành 'hoàn thành' ,dẫn người dung sang TT3) button chuyển động xuống dưới, animate cho 1 đồng hồ countdown xuất hiện thông báo cho người dùng còn 23:59 phút để hoàn thành thử thách đã chọn


TT 3: home với 3 tương quan phía trên, thử thách 24 giờ bên dưới, sau khi user nhấn 'hoàn thành' --> đồng hồ countdown biến mất, xuất hiện dòng chúc mừng bạn đã hoàn thành thử thách. 
nếu hoàn thành thử thách truớc 24 giờ, thử thách cũ sẽ bị gạch ngang, thông báo số giờ còn lại để nhận thử thách mới
sau 24 giờ, trở về TT 1 
không hoàn thành thử thách, trở về TT 1 với alert 'thử thách hết hạn' (TT 4)

2/ Các Category và sub cate:

- tôi đi tìm tôi:

1. Khả năng: ngôn ngữ, trí khôn/hiểu biết, sức khỏe, công việc/ học thức

2. Vật chất: đồ ăn/ thức uống, quần áo/tiện nghi, của cải

3. Thời gian+ hoàn cảnh: tuơng lai, hiện tại/24h sống, quá khứ, vận may, sự ko lành

4. Quyền: quyền làm nguòi, quyền hạnh phúc, quyền tự do, quyền đc sai lầm



- tha nhân:

1. Bổn phận& trách nhiệm: vợ chồng, con cái, cha mẹ, anh chị em, công dân trong xã hội

2. Vật chất: tài sản, môi truòng, động vật/ thụ tạo

3. Thời gian+ hoàn cảnh: thời gian của nguoi khác, niềm vui, nỗi buồn, hoàn cảnh bất hạnh

4. Quyền: quyền tự do, quyền làm nguòi, quyèn sai phạm, quyền hạnh phúc

5. Sức khỏe



- Chúa: 

1. Hoàn cảnh: đc ơn, ko đc ơn

2. Bổn phận: đi lễ, đọc kinh

3. Tin mừng

nội dung của các sub trong đây (có cả thử thách 24h và Lời Chúa): https://docs.google.com/spreadsheets/d/1D1RN98VHujgaIQeR02u0hdqJ9VkC9fpLIrIU7zWk-nw/edit?usp=sharing

3/ Hình giao diện tổng quan:
https://drive.google.com/file/d/1rtxjLqA-LyFWQxlDaQ50JHVt_5nqE42z/view?usp=sharing

4/ design zeplin: 
https://zpl.io/aMOwOQz

5/database diagram
https://dbdiagram.io/d/5f403c1e7b2e2f40e9de5a52
