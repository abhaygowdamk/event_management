<?php

// Include database connection function
include('dbconnection.php');

// Check if username and password are provided
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_POST['username']) && isset($_POST['password'])) {

    // Get username and password from POST data
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Establish database connection
    $conn = dbconnection();

    // Prepare SQL query to check admin credentials
    $query = "SELECT * FROM admins WHERE username = '$username' AND password = '$password'";
    $result = mysqli_query($conn, $query);

    if ($result) {
        if (mysqli_num_rows($result) == 1) {
            // Admin found, return success
            $response['status'] = 'success';
            $response['message'] = 'Admin logged in successfully';
        } else {
            // Admin not found, return error
            $response['status'] = 'error';
            $response['message'] = 'Invalid username or password';
        }
    } else {
        // Database error
        $response['status'] = 'error';
        $response['message'] = 'Database error: ' . mysqli_error($conn);
    }

    // Close database connection
    mysqli_close($conn);

} else {
    // Invalid request
    $response['status'] = 'error';
    $response['message'] = 'Invalid request';
}

// Convert response array to JSON and output
echo json_encode($response);

?>
