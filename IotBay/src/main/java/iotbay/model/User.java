package iotbay.model;

import java.io.Serializable;


public class User implements  Serializable{
    private UserType userType;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String contact;
    private Address address;
    private String status = "active";


    public User() {}

    public User(UserType userType, String firstName, String lastName, String email, String password, String contact, Address address) {
        this.userType = userType;
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
        this.contact = contact;
        this.address = address;

    }

    private int id;

    public int getId(){
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public UserType getUserType() {
        return userType;
    }

    public void setUserType(UserType userType) {
        this.userType = userType;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
        this.address = address;
    }



    public boolean isAdmin() {
        return "admin@iotbay.com".equalsIgnoreCase(this.email);
    }

    public String getStatus() { return status;}
    public void setStatus(String status) { this.status = status;}
    

}


