(: ==========================================
   Mini-Projet XML - Club Info_Tech
   5 استعلامات XQuery - مصححة نهائياً مع شروحات
   ========================================== :)

(: ═════════════════════════════════════════════════════════
   Q1 - قائمة الأعضاء (1 نقطة)
   المطلوب: عرض جميع الأعضاء مع الاسم الكامل والبريد والفئة
   ═════════════════════════════════════════════════════════ :)

<resultat_Q1_ListeMembres>
{
    (: FOR: الدوران على جميع الفئات في المجموعة :)
    for $categorie in collection()//category
    (: LET: استخراج اسم الفئة من العنصر :)
    let $nomCategorie := $categorie/nomCategorie/text()
    (: FOR: الدوران على جميع أعضاء الفئة الحالية :)
    for $membre in $categorie/membres/membre
    (: RETURN: بناء عنصر النتيجة النهائية :)
    return 
        <membre id="{$membre/@id}">
            <nomComplet>{$membre/nom/text()} {$membre/prenom/text()}</nomComplet>
            <email>{$membre/email/text()}</email>
            <categorie>{$nomCategorie}</categorie>
        </membre>
}
</resultat_Q1_ListeMembres>,

(: ═════════════════════════════════════════════════════════
   Q2 - قائمة المسابقات مرتبة (1 نقطة)
   المطلوب: عرض جميع المسابقات مع البيانات مرتبة حسب التاريخ
   ═════════════════════════════════════════════════════════ :)

<resultat_Q2_ListeConcours>
{
    (: FOR: الدوران على جميع عناصر المسابقات :)
    for $concours in collection()//concours
    (: LET: البحث عن الفئة المرتبطة بـ idCategorieCible :)
    let $categorie := collection()//category[@id = $concours/idCategorieCible/text()]
    (: LET: استخراج اسم الفئة من النتيجة :)
    let $nomCategorie := $categorie/nomCategorie/text()
    (: LET: استخراج تاريخ المسابقة :)
    let $date := $concours/dateConcours/text()
    (: ORDER BY: ترتيب النتائج حسب التاريخ من الأقدم للأحدث :)
    order by $date ascending
    (: RETURN: بناء عنصر المسابقة بجميع البيانات :)
    return 
        <concours id="{$concours/@id}">
            <titre>{$concours/nomConcours/text()}</titre>
            <date>{$date}</date>
            <coefficient>{$concours/participants/participant[1]/coefficient/text()}</coefficient>
            <categorieLibelle>{$nomCategorie}</categorieLibelle>
        </concours>
}
</resultat_Q2_ListeConcours>,

(: ═════════════════════════════════════════════════════════
   Q3 - حساب نقاط جميع المشاركين (2 نقطة)
   الصيغة الرياضية: score = (complexite + tempsExecution) × coefficient
   المطلوب: حساب والعرض النقاط لكل مشارك في كل مسابقة
   ═════════════════════════════════════════════════════════ :)

<resultat_Q3_CalculScores>
{
    (: FOR: الدوران على جميع المسابقات المتاحة :)
    for $concours in collection()//concours
    (: LET: استخراج عنوان/اسم المسابقة :)
    let $nomConcours := $concours/nomConcours/text()
    (: FOR: الدوران على جميع المشاركين في المسابقة الحالية :)
    for $participant in $concours/participants/participant
    (: LET: استخراج معرف العضو من خاصية idMembre :)
    let $idMembre := $participant/@idMembre/text()
    (: LET: البحث عن بيانات العضو داخل الفئات وأخذ أول نتيجة :)
    let $membre := (collection()//category/membres/membre[@id = $idMembre])[1]
    (: LET: دمج اسم العضو الكامل (اسم + اسم عائلي) مع إزالة المسافات الزائدة :)
    let $nomMembre := concat(normalize-space($membre/nom/text()), ' ', normalize-space($membre/prenom/text()))
    (: LET: تحويل التعقيد إلى رقم صحيح (integer) :)
    let $complexite := xs:integer($participant/complexite/text())
    (: LET: تحويل وقت التنفيذ إلى رقم صحيح :)
    let $temps := xs:integer($participant/tempsExecution/text())
    (: LET: تحويل المعامل إلى رقم عشري (decimal) :)
    let $coefficient := xs:decimal($participant/coefficient/text())
    (: LET: حساب النقاط النهائية حسب الصيغة الرياضية :)
    let $score := ($complexite + $temps) * $coefficient
    (: RETURN: بناء عنصر النتيجة مع جميع البيانات والنقاط المحسوبة :)
    return 
        <resultatParticipant>
            <titreConcours>{$nomConcours}</titreConcours>
            <nomParticipant>{$nomMembre}</nomParticipant>
            <complexite>{$complexite}</complexite>
            <tempsExecution>{$temps}</tempsExecution>
            <coefficient>{$coefficient}</coefficient>
            <scoreCalcule>{round($score * 100) div 100}</scoreCalcule>
        </resultatParticipant>
}
</resultat_Q3_CalculScores>,

(: ═════════════════════════════════════════════════════════
   Q4 - الفائز الأعلى في كل مسابقة (2 نقطة)
   المطلوب: إيجاد المشارك بأعلى نقاط في كل مسابقة
   في حالة التساوي: عرض جميع الفائزين المتساويين
   ═════════════════════════════════════════════════════════ :)

<resultat_Q4_VainqueursConcours>
{
    (: FOR: الدوران على جميع المسابقات :)
    for $concours in collection()//concours
    (: LET: استخراج عنوان المسابقة :)
    let $nomConcours := $concours/nomConcours/text()
    (: LET: بناء قائمة مؤقتة لجميع المشاركين مع نقاطهم :)
    let $tousParticipants := (
        (: FOR: الدوران على كل مشارك في المسابقة :)
        for $p in $concours/participants/participant
        (: LET: استخراج معرف العضو :)
        let $idMembre := $p/@idMembre/text()
        (: LET: البحث عن بيانات العضو الكامل :)
        let $membre := (collection()//category/membres/membre[@id = $idMembre])[1]
        (: LET: دمج الاسم الكامل مع تنظيف المسافات :)
        let $nomMembre := concat(normalize-space($membre/nom/text()), ' ', normalize-space($membre/prenom/text()))
        (: LET: حساب نقاط المشارك :)
        let $score := (xs:integer($p/complexite/text()) + xs:integer($p/tempsExecution/text())) * xs:decimal($p/coefficient/text())
        (: RETURN: إرجاع عنصر مؤقت يحتوي على الاسم والنقاط :)
        return 
            <participant>
                <nom>{$nomMembre}</nom>
                <score>{$score}</score>
            </participant>
    )
    (: LET: إيجاد أقصى قيمة نقاط من بين جميع المشاركين :)
    let $scoreMax := max($tousParticipants/score/text())
    (: LET: تصفية وأخذ فقط المشاركين الذين حصلوا على أقصى النقاط :)
    let $vainqueurs := $tousParticipants[score = $scoreMax]
    (: RETURN: بناء عنصر النتيجة يحتوي على بيانات المسابقة والفائزين :)
    return 
        <concours>
            <titre>{$nomConcours}</titre>
            <scoreMaximum>{$scoreMax}</scoreMaximum>
            <vainqueurs>
            {
                (: FOR: الدوران على كل فائز :)
                for $v in $vainqueurs
                (: RETURN: عرض بيانات الفائز :)
                return 
                    <vainqueur>
                        <nom>{$v/nom/text()}</nom>
                        <score>{$v/score/text()}</score>
                    </vainqueur>
            }
            </vainqueurs>
        </concours>
}
</resultat_Q4_VainqueursConcours>,

(: ═════════════════════════════════════════════════════════
   Q5 - أعضاء فئة معينة مرتبة (2 نقطة)
   المطلوب: عرض أعضاء فئة محددة مرتبين حسب الاسم الأول ثم الاسم العائلي
   ملاحظة: يمكن تغيير قيمة $categorie لعرض فئة أخرى
   ═════════════════════════════════════════════════════════ :)

<resultat_Q5_MembresParCategorie>
{
    (: LET: تعريف المتغير - اسم الفئة المطلوب البحث عن أعضائها :)
    let $categorie := "Intelligence Artificielle"
    (: LET: البحث عن عنصر الفئة الذي يطابق اسم الفئة المعرف :)
    let $category := collection()//category[nomCategorie = $categorie]
    (: FOR: الدوران على جميع أعضاء الفئة :)
    for $membre in $category/membres/membre
    (: LET: استخراج الاسم العائلي :)
    let $nom := $membre/nom/text()
    (: LET: استخراج الاسم الأول :)
    let $prenom := $membre/prenom/text()
    (: ORDER BY: ترتيب النتائج أولاً حسب الاسم العائلي ثم الاسم الأول بترتيب صاعد :)
    order by $nom ascending, $prenom ascending
    (: RETURN: بناء عنصر النتيجة يحتوي على بيانات العضو :)
    return 
        <membre id="{$membre/@id}">
            <nom>{$nom}</nom>
            <prenom>{$prenom}</prenom>
            <email>{$membre/email/text()}</email>
            <dateInscription>{$membre/dateInscription/text()}</dateInscription>
        </membre>
}
</resultat_Q5_MembresParCategorie>