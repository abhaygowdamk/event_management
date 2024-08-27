<?php
include 'dbconnection.php';

header('Content-Type: application/json'); // Ensure JSON content type

$con = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $usn = $_GET['usn']; // Assuming USN is passed as a query parameter

    // Fetch registered events for the given USN
    $sql = "SELECT r.*, e.name as event_name, e.date as event_date, e.location as event_location 
            FROM registrations r 
            JOIN events e ON r.event_id = e.id 
            WHERE r.usn = '$usn'";

    $result = mysqli_query($con, $sql);
    $registrations = [];

    while ($row = mysqli_fetch_assoc($result)) {
        $registrations[] = $row;
    }

    echo json_encode([
        'status' => 'success',
        'registrations' => $registrations
    ]);

    mysqli_close($con);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
?>
