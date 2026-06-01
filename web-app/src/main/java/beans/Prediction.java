package beans;

public class Prediction {
    private int historyId;
    private int userId;
    private String inputFeatures;
    private int predictionRes;
    private int predictionProbability;
    private String dateOfCreation;

    public Prediction() {}
    public int getHistoryId() {
        return historyId;
    }
    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getInputFeatures() {
        return inputFeatures;
    }
    public void setInputFeatures(String inputFeatures) {
        this.inputFeatures = inputFeatures;
    }
    public int getPredictionRes() {
        return predictionRes;
    }
    public void setPredictionRes(int predictionRes) {
        this.predictionRes = predictionRes;
    }
    public int getPredictionProbability() {
      return predictionProbability;
    }
    public void setPredictionProbability(int predictionProbability) {
      this.predictionProbability = predictionProbability;
    }
    public String getDate() {
        return dateOfCreation;
    }
    public void setDate(String dateOfCreation) {
        this.dateOfCreation = dateOfCreation;
    }
}
