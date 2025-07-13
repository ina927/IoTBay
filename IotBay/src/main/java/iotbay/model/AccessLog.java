package iotbay.model;

import java.sql.Timestamp;
import java.io.Serializable;

public class AccessLog implements Serializable {
    private int logId;
    private int userId;
    private Timestamp loginTime;
    private Timestamp logoutTime;

    public AccessLog(int logId, int userId, Timestamp loginTime, Timestamp logoutTime) {
        this.logId = logId;
        this.userId = userId;
        this.loginTime = loginTime;
        this.logoutTime = logoutTime;
    }

    public int getLogId() {
        return logId;
    }

    public int getUserId() {
        return userId;
    }

    public Timestamp getLoginTime() {
        return loginTime;
    }

    public Timestamp getLogoutTime() {
        return logoutTime;
    }
}
