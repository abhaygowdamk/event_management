<?php
include 'dbconnection.php';

header('Content-Type: application/json');

if (isset($_POST['event_id'])) {
    $eventId = $_POST['event_id'];
    
    $con = dbconnection();
    
    if ($con) {
        $sql = "SELECT name, usn, year, add_members, transaction_id FROM registrations WHERE event_id = ?";
        $stmt = mysqli_prepare($con, $sql);
        mysqli_stmt_bind_param($stmt, "i", $eventId);
        mysqli_stmt_execute($stmt);
        mysqli_stmt_bind_result($stmt, $name, $usn, $year, $addMembers, $transactionId);
        $students = array();
        while (mysqli_stmt_fetch($stmt)) {
            $students[] = array(
                'name' => $name,
                'usn' => $usn,
                'year' => strval($year),  // Convert year to string
                'addMembers' => $addMembers,
                'transactionId' => $transactionId,
            );
        }

        echo json_encode($students);

        mysqli_stmt_close($stmt);
        mysqli_close($con);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Event ID not set']);
}
?>
