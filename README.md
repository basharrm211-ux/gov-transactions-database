# Database Architecture & ERD Documentation

## 1. Tables Structure & Entities Breakdown

- **citizens (جدول المواطنين):**
  * Description: الكيان الأساسي المسجل لبيانات المواطنين مستخدمي النظام.
  * Key Fields: citizen_id (Primary Key), national_no (الرقم الوطني), full_name, phone, city.
  * Role: يمثل الهوية الرقمية للمواطن التي ترتبط بكافة المعاملات والطلبات المقدمة.

- **departments (جدول الأقسام والوزارات):**
  * Description: يمثل الأقسام الإدارية أو الجهات الحكومية المزودة للخدمات.
  * Key Fields: department_id (Primary Key), name.
  * Role: تنظيم الخدمات المتاحة وتوزيع الموظفين والطلبات حسب الاختصاص الإداري.

- **employees (جدول الموظفين):**
  * Description: يتضمن كافة الحسابات والبيانات الوظيفية للموظفين والمديرين.
  * Key Fields: employee_id (Primary Key), department_id (FK), manager_id (Self-FK), job_title, salary.
  * Role: إدارة التسلسل الهرمي للموظفين والتحكم في إسناد المعاملات والخدمات لكل قسم.

- **transaction_types (جدول أنواع المعاملات والخدمات):**
  * Description: الدليل المرجعي لكافة أنواع الخدمات الإلكترونية المتاحة بالنظام.
  * Key Fields: type_id (Primary Key), department_id (FK), name, fee (الرسوم), sla_days (المدة الزمنية).
  * Role: تحدد تكلفة كل خدمة، القسم المسؤول عنها، والمهلة الزمنية المحددة لإنجازها.

- **transactions (جدول المعاملات الرئيسية):**
  * Description: السجل الرئيسي لكل طلب معاملة يتم إنشاؤه في النظام.
  * Key Fields: transaction_id (Primary Key), citizen_id (FK), type_id (FK), status_id (FK).
  * Role: ربط طلب المواطن بنوع الخدمة والحالة الحالية للمعاملة.

- **statuses (جدول حالات المعاملة):**
  * Description: جدولة مرجعية لجميع الحالات التي يمكن أن تمر بها المعاملة.
  * Key Fields: status_id (Primary Key), name (مثال: قيد المعالجة، مكتملة), is_final.
  * Role: توحيد مسميات المراحل وتحديد ما إذا كانت المعاملة وصلت لمرحلتها النهائية أم لا.

- **documents (جدول المرفقات والمستندات):**
  * Description: تخزين بيانات الملفات والوثائق المرفقة مع المعاملات.
  * Key Fields: document_id (Primary Key), transaction_id (FK), file_path.
  * Role: السماح برفع أكثر من وثيقة أو مستند لكل معاملة فردية.

- **payments (جدول المدفوعات والرسوم):**
  * Description: سجل المعاملات المالية الحاصلة على الخدمة.
  * Key Fields: payment_id (Primary Key), transaction_id (FK), amount, method.
  * Role: توثيق المبالغ المدفوعة، وطريقة الدفع، وتاريخ السداد.

- **transaction_history (سجل تتبع المعاملات):**
  * Description: سجل التتبع لتاريخ تغيرات المعاملة.
  * Key Fields: history_id (Primary Key), transaction_id (FK), status_id (FK).
  * Role: حفظ الأرشيف الزمني لجميع التنقلات والتغيرات التي طرأت على حالة المعاملة.

---

## 2. Relationships & Cardinality

- **citizens ---> transactions (One-to-Many):**
  * الشرح: المواطن الواحد يستطيع تقديم عدة معاملات، بينما لا يمكن إنشاء معاملة إلا بوجود مواطن إلزامي مسبقًا.

- **departments ---> employees (One-to-Many):**
  * الشرح: القسم الواحد يضم مجموعة من الموظفين، والموظف يتبع لقسم واحد فقط.

- **employees ---> employees / Self Reference (One-to-Many):**
  * الشرح: الموظف يمكن أن يكون مديرًا لمجموعة موظفين، والموظف العادي يتبع لمدير واحد عبر manager_id.

- **departments ---> transaction_types (One-to-Many):**
  * الشرح: القسم الإداري يملك ويقدم أكثر من نوع معاملة، ولكن نوع المعاملة يتبع لقسم إداري واحد.

- **transaction_types ---> transactions (One-to-Many - Mandatory):**
  * الشرح: نوع الخدمة الواحد يمكن أن يُطلب في آلاف المعاملات، وكل معاملة يجب أن تحدد نوع الخدمة المطلوب إجبارياً.

- **transactions ---> documents (One-to-Many):**
  * الشرح: المعاملة الواحدة قد تتطلب مرفقاً واحداً أو عدة مرفقات ومستندات.

- **transactions ---> payments (One-to-Many):**
  * الشرح: المعاملة يمكن أن تتم لها عملية دفع واحدة أو عدة دفعات جزئية.

- **transactions ---> transaction_history (One-to-Many):**
  * الشرح: المعاملة الواحدة تمتلك سجلاً زمنياً متعدداً يوثق التغيرات الزمانية وحالاتها السابقة.
