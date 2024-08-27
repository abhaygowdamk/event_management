<?php
include 'dbconnection.php';

header('Content-Type: application/json'); // Ensure JSON content type

$con = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $usn = $_POST['usn'];
    $year = $_POST['year'];
    $add_members = $_POST['add_members'];
    $transaction_id = $_POST['transaction_id'];
    $event_id = $_POST['event_id'];
    $event_name = $_POST['event_name'];

    // Fetch event details
    $event_query = "SELECT * FROM events WHERE id = '$event_id'";
    $event_result = mysqli_query($con, $event_query);
    $event = mysqli_fetch_assoc($event_result);

    if ($event) {
        $venue = $event['location'];

        // Insert registration
        $sql = "INSERT INTO registrations (name, usn, year, add_members, transaction_id, event_id, event_name) 
                VALUES ('$name', '$usn', '$year', '$add_members', '$transaction_id', '$event_id', '$event_name')";

        if (mysqli_query($con, $sql)) {
            $registration_id = mysqli_insert_id($con); // Get the last inserted ID for the registration

            // Generate ticket ID (you can customize this as needed)
            $ticket_id = 'TICKET' . $registration_id;

            // Insert ticket details without price
            $ticket_sql = "INSERT INTO tickets (ticket_id, event_name, event_venue, name, registration_id) 
                           VALUES ('$ticket_id', '$event_name', '$venue', '$name', '$registration_id')";

            if (mysqli_query($con, $ticket_sql)) {
                echo json_encode([
                    'status' => 'success',
                    'ticket' => [
                        'ticket_id' => $ticket_id,
                        'event_name' => $event_name,
                        'event_venue' => $venue,
                        'name' => $name
                    ]
                ]);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'Error inserting ticket: ' . mysqli_error($con)]);
            }
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Error inserting registration: ' . mysqli_error($con)]);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Event not found']);
    }

    mysqli_close($con);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
