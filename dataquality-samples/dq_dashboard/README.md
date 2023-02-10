# Sample CloudDQ Looker Studio Dashboard

To build a sample cloudDQ dashboard in Looker Studio, please follow the steps below:

1.  Open a new normal browser window and paste the following link in the navigation bar 
    https://lookerstudio.google.com/u/0/reporting/f728e29c-a2fb-4029-a4c6-cfeee1ca32fa/page/x16FC<br>

2.  Make a copy of the dashboard by click on the details link next to the **Share** button
        ![dashboard Copy ](/dataquality-samples/dq_dashboard/resources/dq_copy_ui.png)

3.  Setup your Looker studio account, if requested 
4.  Leave the New Data Source's defaultsettings(we will set this up later) 
        ![copy-report](/dataquality-samples/dq_dashboard/resources/copy-report.png)
    This will make a copy of the report and have it available in edit mode
5.  Select the **Resource** menu and choose **Manage added data sources** option.
    - Click the **Edit** button under **Action** 
    - **Authorize**, if prompted 
    - Configure your new data source. Select the **edit Connection** option if you want to update the connection.
        -  Select **Project**:  _Provide your project id_ 
        - Select **Dataset**: _Provide the Cloud DQ dataset where your DQ results are stored_ 
        - Select **Table**: dq_summary
        - Click on the **Reconnect** button
        ![Reconnect UI](/dataquality-samples/dq_dashboard/resources/reconnect-ui.png)
    - Click the **Apply** button 
    - Click the **Done** button(right top corner) 
    - Click the **Close** button and then click the **View** button
    - Change the date range if needed and select drill down parameters to refresh the Dashboard. <br>
        ![dq-dashboard](/dataquality-samples/dq_dashboard/resources/dq-dashboard.png)

<br>
Happy Dashboarding! 