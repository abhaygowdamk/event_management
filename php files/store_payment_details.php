<?php
header('Content-Type: application/json');

// Include database connection
include 'dbconnection.php';

// Check if POST data exists
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['event_id']) && isset($_POST['payment_number'])) {

    // Function to store payment details
    function storePaymentDetails($event_id, $payment_number, $payment_qr_image)
    {
        $con = dbconnection();

        // Check connection
        if (!$con) {
            die("Connection failed: " . mysqli_connect_error());
        }

        // Escape user inputs for security
        $event_id = mysqli_real_escape_string($con, $event_id);
        $payment_number = mysqli_real_escape_string($con, $payment_number);

        // File upload handling
        $upload_dir = 'uploads/';
        $file_name = $_FILES['payment_qr_image']['name'];
        $file_tmp = $_FILES['payment_qr_image']['tmp_name'];

        // Move uploaded file to designated directory
        if (move_uploaded_file($file_tmp, $upload_dir . $file_name)) {
            // Insert payment details into database
            $sql = "INSERT INTO payment_details (event_id, payment_number, payment_qr_image) VALUES ('$event_id', '$payment_number', '$upload_dir$file_name')";

            if (mysqli_query($con, $sql)) {
                echo json_encode(array('success' => true, 'message' => 'Payment details stored successfully.'));
            } else {
                echo json_encode(array('success' => false, 'message' => 'Error: ' . mysqli_error($con)));
            }
        } else {
            echo json_encode(array('success' => false, 'message' => 'Failed to upload image.'));
        }

        // Close connection
        mysqli_close($con);
    }

    // Store payment details if all required fields are provided
    if (isset($_FILES['payment_qr_image'])) {
        $event_id = $_POST['event_id'];
        $payment_number = $_POST['payment_number'];

        storePaymentDetails($event_id, $payment_number, $_FILES['payment_qr_image']);
    } else {
        echo json_encode(array('success' => false, 'message' => 'Missing required parameters.'));
    }
} else {
    echo json_encode(array('success' => false, 'message' => 'Invalid request.'));
}
?>
