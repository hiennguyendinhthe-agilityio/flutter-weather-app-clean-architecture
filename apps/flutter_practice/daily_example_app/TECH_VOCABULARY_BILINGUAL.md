# 📚 TECH VOCABULARY - BILINGUAL DICTIONARY
## Flutter & Mobile Development - Vietnamese ↔ English

> **Mục tiêu:** Học từ vựng chuyên ngành IT song ngữ để enhance communication skills và technical understanding

---

## 🏗️ **DEPENDENCY INJECTION - TIÊM PHỤ THUỘC**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Dependency Injection | Tiêm phụ thuộc | Pattern để cung cấp dependencies từ bên ngoài |
| Service Locator | Bộ định vị dịch vụ | Pattern để tìm và lấy services |
| Inversion of Control (IoC) | Đảo ngược điều khiển | Nguyên lý thiết kế để giảm coupling |
| Container | Container/Thùng chứa | Nơi quản lý và cung cấp dependencies |
| Registration | Đăng ký | Quá trình đăng ký service vào container |
| Resolution | Phân giải | Quá trình lấy service từ container |
| Singleton | Đối tượng đơn | Pattern chỉ tạo một instance duy nhất |
| Factory | Nhà máy | Pattern tạo instance mới mỗi lần request |
| Lazy Initialization | Khởi tạo trễ | Tạo object khi cần thiết lần đầu |
| Scope | Phạm vi | Vòng đời của dependency |
| Lifetime | Thời gian sống | Thời gian tồn tại của object |
| Circular Dependency | Phụ thuộc vòng tròn | Khi A phụ thuộc B và B phụ thuộc A |
| Interface | Giao diện | Contract định nghĩa methods |
| Implementation | Triển khai | Code thực thi interface |
| Abstraction | Trừu tượng hóa | Ẩn chi tiết implementation |

### **📝 Common Phrases:**
- **"Inject the dependency"** → **"Tiêm phụ thuộc"**
- **"Register as singleton"** → **"Đăng ký dạng singleton"**
- **"Resolve the service"** → **"Phân giải dịch vụ"**
- **"Loose coupling"** → **"Liên kết lỏng lẻo"**
- **"Tight coupling"** → **"Liên kết chặt chẽ"**

---

## 🔄 **STATE MANAGEMENT - QUẢN LÝ TRẠNG THÁI**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| State Management | Quản lý trạng thái | Cách quản lý và chia sẻ data trong app |
| State | Trạng thái | Dữ liệu có thể thay đổi theo thời gian |
| Provider | Nhà cung cấp | Pattern cung cấp data cho widget tree |
| Consumer | Người tiêu dùng | Widget lắng nghe thay đổi từ Provider |
| ChangeNotifier | Thông báo thay đổi | Class thông báo khi state thay đổi |
| Rebuild | Xây dựng lại | Quá trình vẽ lại widget khi state thay đổi |
| Selector | Bộ chọn | Widget chỉ rebuild khi specific data thay đổi |
| Context | Ngữ cảnh | Thông tin về vị trí widget trong tree |
| Reactive | Phản ứng | UI tự động cập nhật khi data thay đổi |
| Immutable | Bất biến | Object không thể thay đổi sau khi tạo |
| Mutable | Có thể thay đổi | Object có thể modify sau khi tạo |
| Stateful Widget | Widget có trạng thái | Widget có thể thay đổi state |
| Stateless Widget | Widget không trạng thái | Widget không thay đổi sau khi build |
| Lifecycle | Vòng đời | Các giai đoạn từ tạo đến hủy widget |
| Dispose | Giải phóng | Dọn dẹp resources khi không cần |
| Memory Leak | Rò rỉ bộ nhớ | Memory không được giải phóng |
| Performance | Hiệu suất | Tốc độ và efficiency của app |
| Optimization | Tối ưu hóa | Cải thiện performance |

### **📝 Common Phrases:**
- **"Listen to changes"** → **"Lắng nghe thay đổi"**
- **"Notify listeners"** → **"Thông báo cho listeners"**
- **"State updates"** → **"Cập nhật trạng thái"**
- **"Trigger rebuild"** → **"Kích hoạt rebuild"**
- **"Manage state"** → **"Quản lý trạng thái"**

---

## 🌐 **API INTEGRATION - TÍCH HỢP API**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| API (Application Programming Interface) | Giao diện lập trình ứng dụng | Cách các ứng dụng giao tiếp với nhau |
| HTTP Client | Client HTTP | Tool để gửi HTTP requests |
| Request | Yêu cầu | Thông điệp gửi đến server |
| Response | Phản hồi | Thông điệp server trả về |
| Endpoint | Điểm cuối | URL cụ thể của API |
| REST API | API REST | Kiến trúc API theo nguyên tắc REST |
| JSON (JavaScript Object Notation) | Ký hiệu đối tượng JavaScript | Format dữ liệu phổ biến |
| Serialization | Tuần tự hóa | Chuyển object thành JSON |
| Deserialization | Giải tuần tự | Chuyển JSON thành object |
| HTTP Methods | Phương thức HTTP | GET, POST, PUT, DELETE, etc. |
| Status Code | Mã trạng thái | Code báo kết quả request (200, 404, 500) |
| Header | Tiêu đề | Metadata của HTTP request/response |
| Body | Nội dung | Dữ liệu chính của request/response |
| Authentication | Xác thực | Xác minh danh tính user |
| Authorization | Ủy quyền | Kiểm tra quyền truy cập |
| Bearer Token | Token mang | Token để xác thực API calls |
| Interceptor | Bộ chặn | Middleware xử lý request/response |
| Timeout | Hết thời gian | Thời gian chờ tối đa |
| Retry | Thử lại | Gửi lại request khi thất bại |
| Cache | Bộ nhớ đệm | Lưu trữ tạm thời để tăng tốc |
| Offline | Ngoại tuyến | Không có kết nối internet |
| Network Error | Lỗi mạng | Lỗi kết nối internet |
| Server Error | Lỗi máy chủ | Lỗi từ phía server |
| Client Error | Lỗi client | Lỗi từ phía ứng dụng |

### **📝 Common Phrases:**
- **"Make an API call"** → **"Thực hiện cuộc gọi API"**
- **"Handle the response"** → **"Xử lý phản hồi"**
- **"Parse JSON data"** → **"Phân tích dữ liệu JSON"**
- **"Network request failed"** → **"Yêu cầu mạng thất bại"**
- **"Authentication required"** → **"Yêu cầu xác thực"**

---

## 🧪 **TESTING - KIỂM THỬ**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Testing | Kiểm thử | Quá trình kiểm tra tính đúng đắn của code |
| Unit Test | Kiểm thử đơn vị | Test từng function/class riêng lẻ |
| Widget Test | Kiểm thử widget | Test UI components |
| Integration Test | Kiểm thử tích hợp | Test toàn bộ user flow |
| End-to-End (E2E) Test | Kiểm thử đầu cuối | Test complete user journey |
| Mock | Giả lập | Object giả để thay thế dependencies |
| Stub | Sơ khai | Method giả trả về giá trị cố định |
| Test Case | Trường hợp kiểm thử | Một scenario cụ thể để test |
| Test Suite | Bộ kiểm thử | Nhóm các test cases liên quan |
| Assertion | Khẳng định | Kiểm tra kết quả có đúng như mong đợi |
| Coverage | Độ bao phủ | Phần trăm code được test |
| Flaky Test | Test không ổn định | Test đôi khi pass, đôi khi fail |
| Test Driven Development (TDD) | Phát triển hướng kiểm thử | Viết test trước khi viết code |
| Behavior Driven Development (BDD) | Phát triển hướng hành vi | Focus vào behavior của system |
| Regression Test | Kiểm thử hồi quy | Test để đảm bảo không phá vỡ tính năng cũ |
| Smoke Test | Kiểm thử khói | Test cơ bản để đảm bảo app chạy được |
| Load Test | Kiểm thử tải | Test performance với nhiều users |
| Stress Test | Kiểm thử căng thẳng | Test giới hạn của system |

### **📝 Common Phrases:**
- **"Run the tests"** → **"Chạy các bài kiểm thử"**
- **"Test passes/fails"** → **"Kiểm thử thành công/thất bại"**
- **"Mock the dependency"** → **"Giả lập phụ thuộc"**
- **"Assert the result"** → **"Khẳng định kết quả"**
- **"Test coverage"** → **"Độ bao phủ kiểm thử"**

---

## 🏛️ **ARCHITECTURE - KIẾN TRÚC**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Architecture | Kiến trúc | Cách tổ chức và thiết kế hệ thống |
| Design Pattern | Mẫu thiết kế | Giải pháp tái sử dụng cho vấn đề phổ biến |
| Clean Architecture | Kiến trúc sạch | Kiến trúc tách biệt concerns |
| MVVM (Model-View-ViewModel) | Mô hình-Giao diện-Mô hình giao diện | Pattern tách UI logic |
| Repository Pattern | Mẫu kho lưu trữ | Pattern trừu tượng hóa data access |
| Facade Pattern | Mẫu mặt tiền | Pattern đơn giản hóa interface phức tạp |
| Observer Pattern | Mẫu quan sát | Pattern thông báo thay đổi |
| Factory Pattern | Mẫu nhà máy | Pattern tạo objects |
| Builder Pattern | Mẫu xây dựng | Pattern tạo complex objects từng bước |
| Adapter Pattern | Mẫu chuyển đổi | Pattern kết nối incompatible interfaces |
| Separation of Concerns | Tách biệt mối quan tâm | Nguyên tắc chia code theo chức năng |
| Single Responsibility | Trách nhiệm đơn | Mỗi class chỉ có một lý do để thay đổi |
| Open/Closed Principle | Nguyên tắc mở/đóng | Mở cho extension, đóng cho modification |
| Dependency Inversion | Đảo ngược phụ thuộc | Phụ thuộc vào abstraction, không concrete |
| SOLID Principles | Nguyên tắc SOLID | 5 nguyên tắc thiết kế OOP |
| Coupling | Liên kết | Mức độ phụ thuộc giữa các modules |
| Cohesion | Gắn kết | Mức độ liên quan của elements trong module |
| Scalability | Khả năng mở rộng | Khả năng handle tăng trưởng |
| Maintainability | Khả năng bảo trì | Dễ dàng modify và fix bugs |
| Modularity | Tính mô-đun | Chia system thành các parts độc lập |

### **📝 Common Phrases:**
- **"Follow the pattern"** → **"Tuân theo mẫu thiết kế"**
- **"Separate concerns"** → **"Tách biệt mối quan tâm"**
- **"Loose coupling"** → **"Liên kết lỏng lẻo"**
- **"High cohesion"** → **"Gắn kết cao"**
- **"Scalable architecture"** → **"Kiến trúc có thể mở rộng"**

---

## 📱 **FLUTTER SPECIFIC - FLUTTER CHUYÊN BIỆT**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Widget | Widget | Thành phần UI cơ bản trong Flutter |
| Widget Tree | Cây widget | Cấu trúc phân cấp của widgets |
| Build Method | Phương thức build | Method tạo UI của widget |
| Hot Reload | Tải nóng | Cập nhật code mà không restart app |
| Hot Restart | Khởi động nóng | Restart app giữ nguyên debug session |
| Scaffold | Khung | Widget cung cấp structure cơ bản |
| AppBar | Thanh ứng dụng | Thanh tiêu đề ở đầu screen |
| FloatingActionButton | Nút hành động nổi | Nút tròn nổi trên UI |
| Navigator | Điều hướng | Quản lý navigation giữa screens |
| Route | Tuyến đường | Đường dẫn đến một screen |
| Material Design | Thiết kế Material | Design system của Google |
| Cupertino | Cupertino | iOS-style widgets |
| Theme | Chủ đề | Cấu hình màu sắc và style |
| Animation | Hoạt ảnh | Hiệu ứng chuyển động |
| Gesture | Cử chỉ | Tương tác touch như tap, swipe |
| Layout | Bố cục | Cách sắp xếp widgets |
| Constraint | Ràng buộc | Giới hạn kích thước của widget |
| Render | Kết xuất | Quá trình vẽ UI lên màn hình |
| Paint | Sơn | Vẽ pixels lên canvas |
| Composition | Kết hợp | Cách Flutter kết hợp widgets |
| Inheritance | Kế thừa | Widget con nhận properties từ cha |

### **📝 Common Phrases:**
- **"Build the widget"** → **"Xây dựng widget"**
- **"Navigate to screen"** → **"Điều hướng đến màn hình"**
- **"Apply theme"** → **"Áp dụng chủ đề"**
- **"Handle gesture"** → **"Xử lý cử chỉ"**
- **"Animate the transition"** → **"Tạo hoạt ảnh chuyển tiếp"**

---

## 💻 **DEVELOPMENT PROCESS - QUY TRÌNH PHÁT TRIỂN**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Development | Phát triển | Quá trình tạo ra phần mềm |
| Implementation | Triển khai | Viết code thực thi tính năng |
| Debugging | Gỡ lỗi | Tìm và sửa bugs |
| Refactoring | Tái cấu trúc | Cải thiện code mà không thay đổi behavior |
| Code Review | Đánh giá code | Kiểm tra code của đồng nghiệp |
| Pull Request (PR) | Yêu cầu kéo | Request merge code vào main branch |
| Merge | Hợp nhất | Kết hợp code từ nhiều branches |
| Commit | Cam kết | Lưu thay đổi vào version control |
| Branch | Nhánh | Phiên bản song song của code |
| Repository | Kho lưu trữ | Nơi lưu trữ source code |
| Version Control | Kiểm soát phiên bản | Hệ thống theo dõi thay đổi code |
| Git | Git | Hệ thống version control phổ biến |
| Continuous Integration (CI) | Tích hợp liên tục | Tự động build và test code |
| Continuous Deployment (CD) | Triển khai liên tục | Tự động deploy code |
| Build | Xây dựng | Biên dịch code thành app |
| Deploy | Triển khai | Đưa app lên production |
| Release | Phát hành | Công bố phiên bản mới |
| Hotfix | Sửa nóng | Sửa lỗi khẩn cấp |
| Feature | Tính năng | Chức năng của ứng dụng |
| Bug | Lỗi | Sai sót trong code |
| Issue | Vấn đề | Báo cáo lỗi hoặc yêu cầu tính năng |
| Ticket | Phiếu | Task cần hoàn thành |
| Sprint | Sprint | Chu kỳ phát triển ngắn (1-4 tuần) |
| Backlog | Danh sách chờ | Tập hợp các tasks chưa làm |
| Milestone | Cột mốc | Mục tiêu quan trọng trong dự án |

### **📝 Common Phrases:**
- **"Fix the bug"** → **"Sửa lỗi"**
- **"Implement the feature"** → **"Triển khai tính năng"**
- **"Review the code"** → **"Đánh giá code"**
- **"Merge the branch"** → **"Hợp nhất nhánh"**
- **"Deploy to production"** → **"Triển khai lên production"**

---

## 🔧 **TOOLS & TECHNOLOGIES - CÔNG CỤ & CÔNG NGHỆ**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| IDE (Integrated Development Environment) | Môi trường phát triển tích hợp | Tool để viết và debug code |
| VS Code | VS Code | Code editor phổ biến |
| Android Studio | Android Studio | IDE chính thức cho Android |
| Xcode | Xcode | IDE chính thức cho iOS |
| Emulator | Trình giả lập | Phần mềm mô phỏng thiết bị |
| Simulator | Trình mô phỏng | Tool test app trên máy tính |
| Package | Gói | Thư viện code có thể tái sử dụng |
| Plugin | Plugin | Extension thêm tính năng |
| Library | Thư viện | Tập hợp functions và classes |
| Framework | Framework | Nền tảng phát triển ứng dụng |
| SDK (Software Development Kit) | Bộ công cụ phát triển phần mềm | Tools để develop cho platform |
| API Key | Khóa API | Mã xác thực để sử dụng API |
| Environment Variable | Biến môi trường | Cấu hình hệ thống |
| Configuration | Cấu hình | Thiết lập cho app hoặc tool |
| Database | Cơ sở dữ liệu | Nơi lưu trữ dữ liệu |
| Cloud | Đám mây | Dịch vụ computing trên internet |
| Server | Máy chủ | Máy tính cung cấp dịch vụ |
| Client | Client | Ứng dụng sử dụng dịch vụ |
| Backend | Backend | Phần server-side của ứng dụng |
| Frontend | Frontend | Phần user interface của ứng dụng |
| Full-stack | Full-stack | Phát triển cả frontend và backend |

### **📝 Common Phrases:**
- **"Install the package"** → **"Cài đặt gói"**
- **"Configure the environment"** → **"Cấu hình môi trường"**
- **"Connect to database"** → **"Kết nối cơ sở dữ liệu"**
- **"Deploy to cloud"** → **"Triển khai lên đám mây"**
- **"Setup the development environment"** → **"Thiết lập môi trường phát triển"**

---

## 🎯 **PROJECT MANAGEMENT - QUẢN LÝ DỰ ÁN**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Project | Dự án | Tập hợp công việc để đạt mục tiêu |
| Requirement | Yêu cầu | Đặc tả tính năng cần có |
| Specification | Đặc tả | Mô tả chi tiết yêu cầu |
| Scope | Phạm vi | Ranh giới của dự án |
| Timeline | Thời gian biểu | Lịch trình thực hiện |
| Deadline | Hạn chót | Thời điểm phải hoàn thành |
| Priority | Ưu tiên | Mức độ quan trọng |
| Stakeholder | Bên liên quan | Người có lợi ích trong dự án |
| Client | Khách hàng | Người yêu cầu dự án |
| Team Lead | Trưởng nhóm | Người dẫn dắt team |
| Developer | Lập trình viên | Người viết code |
| Designer | Thiết kế viên | Người thiết kế UI/UX |
| Tester | Kiểm thử viên | Người test ứng dụng |
| Product Owner | Chủ sản phẩm | Người quyết định tính năng |
| Scrum Master | Scrum Master | Người điều phối Scrum process |
| Agile | Agile | Phương pháp phát triển linh hoạt |
| Scrum | Scrum | Framework Agile phổ biến |
| Kanban | Kanban | Phương pháp quản lý workflow |
| Stand-up | Stand-up | Họp ngắn hàng ngày |
| Retrospective | Hồi cố | Đánh giá và cải thiện process |
| Demo | Demo | Trình diễn tính năng |
| User Story | Câu chuyện người dùng | Mô tả tính năng từ góc độ user |
| Acceptance Criteria | Tiêu chí chấp nhận | Điều kiện để tính năng được chấp nhận |

### **📝 Common Phrases:**
- **"Meet the deadline"** → **"Đáp ứng hạn chót"**
- **"Gather requirements"** → **"Thu thập yêu cầu"**
- **"Prioritize tasks"** → **"Ưu tiên các công việc"**
- **"Deliver the project"** → **"Giao nộp dự án"**
- **"Manage the scope"** → **"Quản lý phạm vi"**

---

## 🚀 **PERFORMANCE & OPTIMIZATION - HIỆU SUẤT & TỐI ƯU**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Performance | Hiệu suất | Tốc độ và efficiency của app |
| Optimization | Tối ưu hóa | Cải thiện performance |
| Bottleneck | Nút thắt cổ chai | Điểm gây chậm trong system |
| Latency | Độ trễ | Thời gian phản hồi |
| Throughput | Thông lượng | Lượng work xử lý được trong thời gian |
| Load Time | Thời gian tải | Thời gian để app khởi động |
| Response Time | Thời gian phản hồi | Thời gian xử lý request |
| Memory Usage | Sử dụng bộ nhớ | Lượng RAM app sử dụng |
| CPU Usage | Sử dụng CPU | Lượng processor app sử dụng |
| Battery Drain | Tiêu hao pin | Lượng pin app sử dụng |
| Frame Rate | Tốc độ khung hình | Số frames per second |
| Smooth Animation | Hoạt ảnh mượt | Animation chạy 60fps |
| Jank | Giật lag | Animation không mượt |
| Profiling | Phân tích hiệu suất | Đo lường performance |
| Benchmark | Đánh giá chuẩn | So sánh performance |
| Caching | Bộ nhớ đệm | Lưu trữ tạm để tăng tốc |
| Lazy Loading | Tải trễ | Chỉ tải khi cần thiết |
| Code Splitting | Chia tách code | Chia app thành chunks nhỏ |
| Minification | Thu nhỏ | Giảm kích thước code |
| Compression | Nén | Giảm kích thước dữ liệu |

### **📝 Common Phrases:**
- **"Optimize performance"** → **"Tối ưu hiệu suất"**
- **"Reduce memory usage"** → **"Giảm sử dụng bộ nhớ"**
- **"Improve load time"** → **"Cải thiện thời gian tải"**
- **"Profile the app"** → **"Phân tích hiệu suất ứng dụng"**
- **"Cache the data"** → **"Lưu đệm dữ liệu"**

---

## 🔒 **SECURITY - BẢO MẬT**

| **English** | **Vietnamese** | **Definition/Usage** |
|-------------|----------------|----------------------|
| Security | Bảo mật | Bảo vệ khỏi các mối đe dọa |
| Authentication | Xác thực | Xác minh danh tính |
| Authorization | Ủy quyền | Kiểm tra quyền truy cập |
| Encryption | Mã hóa | Biến đổi dữ liệu thành dạng bí mật |
| Decryption | Giải mã | Chuyển dữ liệu mã hóa về dạng gốc |
| Hash | Băm | Biến đổi dữ liệu thành chuỗi cố định |
| Salt | Muối | Dữ liệu random thêm vào hash |
| Token | Token | Mã xác thực tạm thời |
| JWT (JSON Web Token) | Token Web JSON | Format token phổ biến |
| OAuth | OAuth | Protocol ủy quyền |
| SSL/TLS | SSL/TLS | Protocol mã hóa kết nối |
| HTTPS | HTTPS | HTTP với mã hóa |
| Certificate | Chứng chỉ | Xác thực danh tính server |
| Vulnerability | Lỗ hổng | Điểm yếu có thể bị tấn công |
| Attack | Tấn công | Hành vi xâm nhập bất hợp pháp |
| Firewall | Tường lửa | Bảo vệ mạng khỏi truy cập trái phép |
| Penetration Testing | Kiểm thử xâm nhập | Test bảo mật bằng cách tấn công |
| Data Breach | Vi phạm dữ liệu | Rò rỉ thông tin nhạy cảm |
| Privacy | Quyền riêng tư | Bảo vệ thông tin cá nhân |
| GDPR | GDPR | Quy định bảo vệ dữ liệu EU |

### **📝 Common Phrases:**
- **"Secure the data"** → **"Bảo mật dữ liệu"**
- **"Authenticate the user"** → **"Xác thực người dùng"**
- **"Encrypt sensitive information"** → **"Mã hóa thông tin nhạy cảm"**
- **"Prevent security breach"** → **"Ngăn chặn vi phạm bảo mật"**
- **"Implement security measures"** → **"Triển khai các biện pháp bảo mật"**

---

## 📊 **COMMON TECHNICAL PHRASES - CỤM TỪ KỸ THUẬT THÔNG DỤNG**

### **🔄 Process & Actions**
| **English** | **Vietnamese** |
|-------------|----------------|
| "Let's implement this feature" | "Hãy triển khai tính năng này" |
| "We need to refactor this code" | "Chúng ta cần tái cấu trúc code này" |
| "The build is failing" | "Quá trình build đang thất bại" |
| "Deploy to production" | "Triển khai lên production" |
| "Run the tests" | "Chạy các bài kiểm thử" |
| "Debug the issue" | "Gỡ lỗi vấn đề này" |
| "Optimize the performance" | "Tối ưu hiệu suất" |
| "Handle the error" | "Xử lý lỗi" |
| "Parse the JSON" | "Phân tích JSON" |
| "Validate the input" | "Xác thực đầu vào" |

### **🎯 Problem Solving**
| **English** | **Vietnamese** |
|-------------|----------------|
| "What's the root cause?" | "Nguyên nhân gốc là gì?" |
| "Let's troubleshoot this" | "Hãy khắc phục sự cố này" |
| "This is a critical bug" | "Đây là lỗi nghiêm trọng" |
| "We have a memory leak" | "Chúng ta có rò rỉ bộ nhớ" |
| "The app is crashing" | "Ứng dụng đang bị crash" |
| "Performance is degraded" | "Hiệu suất bị suy giảm" |
| "Let's profile the code" | "Hãy phân tích hiệu suất code" |
| "We need to scale up" | "Chúng ta cần mở rộng quy mô" |

### **📋 Planning & Discussion**
| **English** | **Vietnamese** |
|-------------|----------------|
| "What are the requirements?" | "Yêu cầu là gì?" |
| "Let's break down the task" | "Hãy chia nhỏ công việc" |
| "What's the timeline?" | "Thời gian biểu là gì?" |
| "This is out of scope" | "Điều này nằm ngoài phạm vi" |
| "Let's prioritize this" | "Hãy ưu tiên điều này" |
| "We need more resources" | "Chúng ta cần thêm tài nguyên" |
| "Let's schedule a review" | "Hãy lên lịch đánh giá" |
| "The deadline is approaching" | "Hạn chót đang đến gần" |

---

## 🎓 **LEARNING TIPS - MẸO HỌC TẬP**

### **📚 How to Use This Dictionary:**

1. **Daily Review (15 minutes):**
   - Đọc 10-15 từ mỗi ngày
   - Practice pronunciation
   - Use in sentences

2. **Context Learning:**
   - Học từ trong context của project
   - Kết hợp với technical documentation
   - Practice trong daily standups

3. **Active Usage:**
   - Viết comments bằng tiếng Anh
   - Tham gia discussions trên GitHub
   - Đọc technical blogs

4. **Spaced Repetition:**
   - Review từ cũ định kỳ
   - Tạo flashcards cho từ khó
   - Practice với colleagues

### **🗣️ Speaking Practice:**

**Daily Phrases to Practice:**
- "I'm working on implementing the authentication feature"
- "We need to optimize the API calls for better performance"
- "Let me debug this issue and get back to you"
- "The unit tests are passing but integration tests are failing"
- "We should refactor this code to improve maintainability"

### **📖 Reading Practice:**

**Recommended Resources:**
- Flutter documentation (flutter.dev)
- Medium articles về Flutter
- Stack Overflow discussions
- GitHub repositories
- Technical blogs

### **✍️ Writing Practice:**

**Daily Tasks:**
- Viết commit messages bằng tiếng Anh
- Comment code bằng tiếng Anh
- Tạo technical documentation
- Participate in code reviews

---

## 🎯 **PRONUNCIATION GUIDE - HƯỚNG DẪN PHÁT ÂM**

### **Common Mispronunciations:**

| **Word** | **Correct** | **Vietnamese Tendency** |
|----------|-------------|-------------------------|
| Cache | /kæʃ/ (cash) | /keɪʃ/ (kay-sh) |
| Route | /ruːt/ (root) | /raʊt/ (rout) |
| Query | /ˈkwɪəri/ (kweer-ee) | /ˈkweri/ (kway-ree) |
| Schema | /ˈskiːmə/ (skee-ma) | /ˈʃiːmə/ (shee-ma) |
| Async | /eɪˈsɪŋk/ (ay-sink) | /æˈsɪŋk/ (a-sink) |
| Boolean | /ˈbuːliən/ (boo-lee-an) | /ˈbuːlɪən/ (boo-li-an) |
| Integer | /ˈɪntɪdʒər/ (in-ti-jer) | /ˈɪnteɪgər/ (in-tay-ger) |

### **Technical Acronyms:**

| **Acronym** | **Pronunciation** | **Full Form** |
|-------------|-------------------|---------------|
| API | /eɪ piː aɪ/ (ay-pee-eye) | Application Programming Interface |
| JSON | /ˈdʒeɪsən/ (jay-son) | JavaScript Object Notation |
| HTTP | /eɪtʃ tiː tiː piː/ (aych-tee-tee-pee) | HyperText Transfer Protocol |
| URL | /juː ɑːr el/ (you-are-el) | Uniform Resource Locator |
| SDK | /es diː keɪ/ (es-dee-kay) | Software Development Kit |
| IDE | /aɪ diː iː/ (eye-dee-ee) | Integrated Development Environment |
| UI | /juː aɪ/ (you-eye) | User Interface |
| UX | /juː eks/ (you-ex) | User Experience |

---

## 💼 **WORKPLACE COMMUNICATION - GIAO TIẾP NƠI LÀM VIỆC**

### **📧 Email Templates:**

**Reporting Progress:**
```
Subject: Weekly Progress Update - [Project Name]

Hi [Manager Name],

Here's my progress update for this week:

Completed:
- Implemented user authentication with JWT tokens
- Fixed the memory leak in the image loading component
- Added unit tests for the API service layer

In Progress:
- Refactoring the state management architecture
- Optimizing the app performance for low-end devices

Blockers:
- Waiting for API documentation from the backend team
- Need clarification on the user permission requirements

Next Week:
- Complete the state management refactoring
- Implement the offline caching mechanism
- Conduct code review with the team

Best regards,
[Your Name]
```

**Asking for Help:**
```
Subject: Need Help with Flutter Performance Issue

Hi [Colleague Name],

I'm experiencing a performance issue in our Flutter app and would appreciate your expertise.

Issue:
The ListView with 1000+ items is causing significant frame drops and memory usage spikes.

What I've tried:
- Implemented ListView.builder for lazy loading
- Added const constructors where possible
- Profiled the app using Flutter Inspector

Current metrics:
- Memory usage: 150MB (expected: <100MB)
- Frame rate: 45fps (target: 60fps)

Could you help me identify potential optimizations? I'm available for a quick call this afternoon if that works for you.

Thanks in advance!
[Your Name]
```

### **💬 Meeting Phrases:**

**Starting Discussions:**
- "Let's discuss the architecture approach"
- "I'd like to propose a different solution"
- "What are your thoughts on this implementation?"
- "Could you walk me through your approach?"

**Asking Questions:**
- "Could you clarify the requirements?"
- "What's the expected behavior in this scenario?"
- "How should we handle edge cases?"
- "What's the performance target for this feature?"

**Providing Updates:**
- "I've completed the authentication module"
- "The API integration is 80% done"
- "I'm blocked on the third-party library issue"
- "The tests are passing locally but failing in CI"

**Suggesting Solutions:**
- "We could implement caching to improve performance"
- "I suggest we refactor this using the repository pattern"
- "Maybe we should add error boundaries here"
- "Let's consider using a state management solution"

---

## 🚀 **CAREER DEVELOPMENT - PHÁT TRIỂN SỰ NGHIỆP**

### **📈 Technical Skills Progression:**

**Junior Developer:**
- Basic Flutter widgets and layouts
- Simple state management
- API integration fundamentals
- Basic testing concepts

**Mid-level Developer:**
- Advanced state management patterns
- Complex UI implementations
- Performance optimization
- Comprehensive testing strategies

**Senior Developer:**
- Architecture design
- Team mentoring
- Code review leadership
- Technical decision making

### **🎯 Goal Setting Phrases:**

**Short-term Goals:**
- "I want to master dependency injection patterns"
- "My goal is to improve test coverage to 90%"
- "I'm focusing on learning advanced Flutter animations"
- "I aim to optimize our app's performance metrics"

**Long-term Goals:**
- "I want to become a Flutter expert in our team"
- "My goal is to lead a mobile development project"
- "I'm working towards becoming a technical architect"
- "I want to contribute to open-source Flutter packages"

### **💪 Self-Assessment Questions:**

**Technical Skills:**
- "How comfortable am I with complex state management?"
- "Can I design scalable Flutter architectures?"
- "Do I follow testing best practices consistently?"
- "Am I up-to-date with the latest Flutter features?"

**Soft Skills:**
- "How effectively do I communicate technical concepts?"
- "Can I mentor junior developers?"
- "Do I contribute positively to code reviews?"
- "Am I proactive in identifying and solving problems?"

---

## 📚 **CONTINUOUS LEARNING - HỌC TẬP LIÊN TỤC**

### **🎯 Learning Plan Template:**

**Weekly Learning Goals:**
```
Week [Number]: [Topic Focus]

Objectives:
- Learn [specific concept]
- Practice [specific skill]
- Build [specific project]

Resources:
- Documentation: [links]
- Tutorials: [links]
- Practice projects: [descriptions]

Success Metrics:
- Complete [specific tasks]
- Achieve [specific outcomes]
- Demonstrate [specific skills]
```

### **📖 Recommended Learning Path:**

**Month 1: Foundations**
- Master basic Flutter concepts
- Learn Dart language fundamentals
- Practice with simple projects

**Month 2: Intermediate Skills**
- Advanced state management
- API integration patterns
- Testing methodologies

**Month 3: Advanced Topics**
- Architecture patterns
- Performance optimization
- Production deployment

**Month 4: Specialization**
- Choose focus area (animations, performance, architecture)
- Contribute to open source
- Mentor others

---

**🎉 Congratulations on your commitment to bilingual technical learning! This dictionary will be your companion throughout your Flutter development journey. Remember to practice regularly and use these terms in real conversations and projects.**

**Good luck with your technical English journey! 🚀**