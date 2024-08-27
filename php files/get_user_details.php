<?php
include 'dbconnection.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $con = dbconnection();
    
    // Assuming you have session management to get the current user's ID
    session_start();
    $userId = $_SESSION['user_id']; // Replace with your actual method to get the user ID

    $query = "SELECT uname AS username, uemail AS email, uphone AS phone FROM users WHERE id = ?";
    $stmt = $con->prepare($query);
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    echo json_encode($user);

    $stmt->close();
    mysqli_close($con);
}
?>
