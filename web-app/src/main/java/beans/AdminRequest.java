package beans;

public class AdminRequest {
    private int id;
    private int userId;
    private String email; 
    private String message;
    private String status;

    public AdminRequest() {}
    public int getId(){
        return id;
        }
    public void setId(int id){
        this.id = id;
        }
    public int getUserId(){
        return userId;
        }
    public void setUserId(int userId){
        this.userId = userId;
        }
    public String getEmail(){
        return email;
        }
    public void setEmail(String email){
        this.email = email;
        }
    public String getMessage(){
        return message;
        }
    public void setMessage(String message){
        this.message = message;
        }
    public String getStatus(){
        return status;
        }
    public void setStatus(String status){
        this.status = status;
        }
}