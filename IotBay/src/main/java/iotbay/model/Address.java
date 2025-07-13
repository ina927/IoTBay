package iotbay.model;

import java.io.Serializable;

public class Address implements Serializable {
    private String address;
    private String suburb;
    private String state;
    private String postcode;

    public Address() {}

    public Address(String address, String suburb, String state, String postcode) {
        this.address = address;
        this.suburb = suburb;
        this.state = state;
        this.postcode = postcode;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getSuburb() {
        return suburb;
    }

    public void setSuburb(String suburb) {
        this.suburb = suburb;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
