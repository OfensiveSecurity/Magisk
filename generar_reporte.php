<?php
require('fpdf.php');

$pdf = new FPDF();
$pdf->AddPage();
$pdf->SetFont('Arial','B',16);
$pdf->Cell(40,10,'NEXUS SYSTEM - REPORTE DE AUDITORIA');
$pdf->Ln(20);

$pdf->SetFont('Arial','',12);
$pdf->Cell(40,10,'Fecha: ' . date("Y-m-d H:i:s"));
$pdf->Ln(10);

// Leer los logs de intrusos y credenciales
$log_content = file_get_contents('/sdcard/www/nexus_audit.log');
$pdf->MultiCell(0,10, "Historial de Actividad:\n" . $log_content);

$pdf->Output('D', 'Reporte_Nexus.pdf'); // 'D' fuerza la descarga directa
?>
