<?php
include 'dbconnection.php'; // Include the file that contains the dbconnection function

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $con = dbconnection();

    // Check if all required fields are present
    if (isset($_POST['event_id']) && isset($_POST['number'])) {
        $eventId = $_POST['event_id'];
        $number = $_POST['number'];
        
        // Handle file upload if payment image is present
        if (isset($_FILES['payment_image']) && $_FILES['payment_image']['error'] == UPLOAD_ERR_OK) {
            $uploadDir = '/path/to/your/upload/directory/'; // Adjust path as per your server setup
            $uploadFile = $uploadDir . basename($_FILES['payment_image']['name']);

            if (move_uploaded_file($_FILES['payment_image']['tmp_name'], $uploadFile)) {
                // File uploaded successfully, now prepare the query to insert details
                $sql = "INSERT INTO event_details (event_id, number, payment_image_path) 
                        VALUES ('$eventId', '$number', '$uploadFile')";

                if (mysqli_query($con, $sql)) {
                    // If insertion is successful, fetch inserted details
                    $insertedId = mysqli_insert_id($con);
                    $selectSql = "SELECT * FROM event_details WHERE id = $insertedId";
                    $result = mysqli_query($con, $selectSql);

                    if ($result) {
                        $row = mysqli_fetch_assoc($result);
                        echo json_encode(['status' => 'success', 'message' => 'Details added successfully', 'data' => $row]);
                    } else {
                        echo json_encode(['status' => 'error', 'message' => 'Failed to fetch inserted details']);
                    }
                } else {
                    // If insertion fails
                    echo json_encode(['status' => 'error', 'message' => 'Error: ' . mysqli_error($con)]);
                }
            } else {
                // Failed to move uploaded file to destination
                echo json_encode(['status' => 'error', 'message' => 'Failed to move uploaded file']);
            }
        } else {
            // No payment image uploaded, insert without payment image
            $sql = "INSERT INTO event_details (event_id, number) 
                    VALUES ('$eventId', '$number')";

            if (mysqli_query($con, $sql)) {
                // If insertion is successful, fetch inserted details
                $insertedId = mysqli_insert_id($con);
                $selectSql = "SELECT * FROM event_details WHERE id = $insertedId";
                $result = mysqli_query($con, $selectSql);

                if ($result) {
                    $row = mysqli_fetch_assoc($result);
                    echo json_encode(['status' => 'success', 'message' => 'Details added successfully', 'data' => $row]);
                } else {
                    echo json_encode(['status' => 'error', 'message' => 'Failed to fetch inserted details']);
                }
            } else {
                // If insertion fails
                echo json_encode(['status' => 'error', 'message' => 'Error: ' . mysqli_error($con)]);
            }
        }
    } else {
        // If required fields are missing
        echo json_encode(['status' => 'error', 'message' => 'Missing required fields']);
    }

    mysqli_close($con);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}
?>
