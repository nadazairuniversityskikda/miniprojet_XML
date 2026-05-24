<?php
// تحديد مسار ملف الـ XML وقراءته
$xmlFile = 'club.xml';

if (!file_exists($xmlFile)) {
    die("<div style='color:white; background:red; padding:20px; text-align:center;'>خطأ: ملف club.xml غير موجود في المسار المطلوب.</div>");
}

$xml = simplexml_load_file($xmlFile);

// حساب إحصائيات سريعة للبطاقات العليا
$totalMembers = 0;
foreach($xml->categories->category as $cat) {
    $totalMembers += count($cat->membres->membre);
}
$totalCategories = count($xml->categories->category);
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Club Info_Tech - Premium Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    
    <header>
        <h1>Club Info_Tech Dashboard</h1>
        <p>Système de Gestion Dynamique & Analyse des Performances • XML / PHP</p>
    </header>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-info">
                <h3>Membres Enregistrés</h3>
                <div class="number"><?= $totalMembers ?></div>
            </div>
            <div class="stat-icon icon-members">
                <i class="fas fa-users"></i>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-info">
                <h3>Spécialités (Catégories)</h3>
                <div class="number"><?= $totalCategories ?></div>
            </div>
            <div class="stat-icon icon-categories">
                <i class="fas fa-layer-group"></i>
            </div>
        </div>
    </div>

    <section>
        <h2 class="section-title"><span></span><i class="fas fa-id-card" style="margin-right:10px;"></i> Répartition des Membres par Spécialité</h2>
        
        <?php foreach ($xml->categories->category as $category): ?>
            <div class="category-block">
                <div class="category-header">
                    <div class="category-title">
                        <i class="fas fa-laptop-code" style="color:#3b82f6; margin-right:10px;"></i>
                        <?= htmlspecialchars($category->nomCategorie) ?>
                    </div>
                    <div class="category-badge">
                        <?= htmlspecialchars($category['id']) ?>
                    </div>
                </div>
                
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nom & Prénom</th>
                                <th>Adresse Email</th>
                                <th>Date d'Inscription</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($category->membres->membre as $membre): ?>
                            <tr>
                                <td><span class="id-badge"><?= htmlspecialchars($membre['id']) ?></span></td>
                                <td style="font-weight: 600; color: #fff;"><?= htmlspecialchars($membre->nom) ?> <?= htmlspecialchars($membre->prenom) ?></td>
                                <td class="text-muted"><?= htmlspecialchars($membre->email) ?></td>
                                <td><i class="far fa-calendar-alt" style="margin-right: 5px; color:#10b981;"></i> <?= htmlspecialchars($membre->dateInscription) ?></td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        <?php endforeach; ?>
    </section>

    <section>
        <h2 class="section-title"><span></span><i class="fas fa-trophy" style="margin-right:10px;"></i> Résultats des Concours & Performance Scores</h2>

        <?php foreach ($xml->concoursList->concours as $concours): ?>
            <div class="category-block" style="border-left: 4px solid var(--secondary);">
                <div class="category-header">
                    <div class="category-title" style="color: #3b82f6;">
                        <i class="fas fa-award" style="margin-right:10px;"></i>
                        <?= htmlspecialchars($concours->nomConcours) ?>
                    </div>
                    <div class="category-badge concours-badge">
                        <i class="far fa-clock"></i> <?= htmlspecialchars($concours->dateConcours) ?>
                    </div>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>ID Participant</th>
                                <th>Complexité</th>
                                <th>Temps d'Exécution</th>
                                <th>Coefficient</th>
                                <th>Score Final Calculé</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php 
                            foreach ($concours->participants->participant as $p): 
                                // تطبيق المعادلة البيداغوجية المطلوبة: (التعقيد + الوقت) * المعامل
                                $complexite = (int)$p->complexite;
                                $temps = (int)$p->tempsExecution;
                                $coeff = (float)$p->coefficient;
                                $score = ($complexite + $temps) * $coeff;
                            ?>
                            <tr>
                                <td><span class="id-badge"><?= htmlspecialchars($p['idMembre']) ?></span></td>
                                <td>
                                    <?php for($i=1; $i<=5; $i++) {
                                        echo $i <= $complexite ? "<i class='fas fa-star' style='color:#f59e0b;'></i>" : "<i class='far fa-star' style='color:var(--text-muted);'></i>";
                                    } ?>
                                </td>
                                <td><?= $temps ?> <span class="text-muted">minutes</span></td>
                                <td><span class="id-badge" style="color:var(--secondary);"><?= $coeff ?></span></td>
                                <td class="score-text"><i class="fas fa-bolt"></i> <?= $score ?> <span style="font-size:0.8rem; font-weight:normal;">pts</span></td>
                            </tr>
                            <?php endforeach; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        <?php endforeach; ?>
    </section>

</div>

</body>
</html>