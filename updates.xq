(: ==========================================
   Mini-Projet XML - Club Info_Tech
   Fichier: updates.xq (ملف عمليات التحديث المباشر)
   ========================================== :)

(: 
   1. عملية الإضافة (Insertion)
   المطلوب: إضافة عضو جديد تماماً إلى تخصص الأمن السيبراني (CAT03).
   اخترنا الطالبة "BOUACHARI SARRA" من القائمة الرسمية المرفقة.
:)
insert node 
    <membre id="M051">
        <nom>BOUACHARI</nom>
        <prenom>SARRA</prenom>
        <email>s.bouachari@club.dz</email>
        <dateInscription>2026-05-22</dateInscription>
    </membre>
as last into collection()//category[@id = "CAT03"]/membres,

(: 
   2. عملية التعديل (Modification)
   المطلوب: تعديل وقت التنفيذ (tempsExecution) لأحد المشاركين في المسابقات.
   سنقوم بتحديث وقت المشاركة الخاص بـ NADA ZAIR في المسابقة C03 ليصبح 70 دقيقة بدلاً من 75.
:)
replace value of node collection()//concours[@id = "C03"]/participants/participant[@idMembre = "M050"]/tempsExecution
with 70,

(: 
   3. عملية الحذف (Suppression)
   المطلوب: حذف عضو من النادي.
   سنقوم بحذف العضو ذو المعرف "M016" (MOHAMED NAZIM) من تخصص الذكاء الاصطناعي (CAT01).
:)
delete node collection()//category[@id = "CAT01"]/membres/membre[@id = "M016"]