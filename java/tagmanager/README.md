# Sample Tags and Tag templates 
This repository contains a source code that automate the metadata management process in the Data as a Product lifecycle for Dataplex managed data assets. The utulity can be run in stand-alone more as well as orchestrated using Dataplex's custom tasks utility, which is based on the Sparkservelss service and can be readily customized by developers.

With this set of automation code, you'll be able to build data-as-a-products and annotate them at scale which is a primary challenge. The tool now supports automated annotations for the following:

- Data product classfication (Table-level only)
- Data product quality
- Data product info - contains ownership and domain info
- Data product exchange
- Data product versioning(TBD)
- Data product cost metric(TBD)
- Data product consumption info(TBD)
- Data product retention policy(TBD)

Currently only supports BigQuery and Zcloud storage only. Tool can be easily extended to support other storages in future. 

Under-the-hood, this modules makes use of the below underlying GCP technologies:
- Google Cloud Dataplex
- Google Cloud DLP(as a pre-requisite only.)
- Google Cloud Data Catalog
- Google Cloud Logging
- Google Cloud Billing
- Google Cloud Analytic Hub

A centralized team should be responsible for owning and maintainng this repository and Data Product Owners/Domain team should be able use thus module to automate annotations of their data products.

## Pre-requisites
- While the code is very flexbile in terms of implement, a set of pre-requisites are required to automate metadata annotations end-to-end.

    1. Dataplex - Logically organize your data products into lakes,zones and assets
    2. DLP - Enable automatic DLP for BigQuery
    3. Create tag templates in Data Catalog
    4. Data Quality Results from CloudDQ engine

    Each templated will require a certain input for end-to-end automation.

# Getting Started

## Requirements
- Java 8
- Maven 3

1. Clone this repository:

    ```
    git clone https://github.com/mansim07/dataplex-utils.git

    cd dataplex-utils/java/tagmanager/
    ```
2.  Set the GOOGLE_APPLICATION_CREDENTIALS environment variable to point to a service account key JSON file path.

    Learn more at [Setting Up Authentication for Server to Server Production Applications][ADC].

    Note: Application Default Credentials is able to implicitly find the credentials as long as the application is running on Compute Engine, Kubernetes Engine, App Engine, or Cloud Functions.

3. Format Code
    ```
    mvn spotless:apply
    ```
    This will format the code and add a license header. To verify that the code is formatted correctly, run:

    ```
        mvn spotless:check
    ```

4. Building the Project
    Build the entire project using the maven compile command.
    ```
        mvn clean install
    ```

5. Upload the output jar to a gs bucket
    ```
    gs util cp tagmanager-1.0-SNAPSHOT.jar gs://<bucket-name>/<<folder-name>>
    ```

## Creating the Data Product Information Tag 

- Step 1: Create the "data_product_information" tag template

    Run the below script to create the data_product_information tag template 
    ```
    java -cp target/tagmanager-1.0-SNAPSHOT.jar  com.google.cloud.dataplex.setup.CreateTagTemplates <<project-name>> <<location>> data_product_information
    ```

- Step 2: Prepare your input yaml file 

    ```
    data_product_id: derived
    data_product_name: ""
    data_product_type: ""
    data_product_description: "" 
    data_product_icon: ""
    data_product_category: ""
    data_product_geo_region: ""
    data_product_owner: "alexandra.gill@boma.com"
    data_product_documentation: ""
    domain: derived
    domain_owner: "rebecca.piper@boma.com"
    domain_type: "" 
    last_modified_by: ""
    last_modify_date: ""
    ```

    ```
    gsutil cp ~/customer-tag.yaml gs://${PROJECT_ID}_dataplex_temp/
    ```

- Step 3: Run the command to create a tag on Dataplex entity  
    - Option 1: Local-mode 
        ```
        mvn exec:java -Dexec.mainClass=test.Main -Dexec.args="arg1 arg2 arg3" 
        ```

    - Option 2: Dataplex custom task 
        ```
        EXPORT PROJECT_ID="your-project-id"
        EXPORT LOCATION="location"
        EXPORT VPC_NETWORK="projects/${PROJECT_ID}/regions/${LOCATION}/subnetworks/subnet-name"
        EXPORT SERVICE_ACCOUNT="customer-sa@${PROJECT_ID}.iam.gserviceaccount.com"
        EXPORT INPUT_YAML_PATH="gs://${PROJECT_ID}_dataplex_temp"
        EXPORT INPUT_YAML_FILENAME="customer-tag.yaml"
        EXPORT JAR_FILE="gs://${PROJECT_ID}_dataplex_process/common/tagmanager-1.0-SNAPSHOT.jar"
        EXPORT LAKE_ID="your-lake-name"
        EXPORT ZONE_ID="your-zone-id"
        EXPORT ENTITY_ID="your-entity-id"
        

        gcloud dataplex tasks create sample-dp-info-tag-job \
        --project=${PROJECT_ID} \
        --location=${LOCATION} \
        --vpc-sub-network-name=${VPC_NETWORK} \
        --lake=${LAKE_ID} \
        --trigger-type=ON_DEMAND \
        --execution-service-account=${SERVICE_ACCOUNT} \
        --spark-main-class="com.google.cloud.dataplex.templates.dataproductinformation.DataProductInfo" \
        --spark-file-uris="${INPUT_YAML_PATH}/${INPUT_YAML_FILENAME}" \
        --container-image-java-jars="${JAR_FILE}" \
        --execution-args=^::^TASK_ARGS="--tag_template_id=projects/${PROJECT_ID}/locations/${LOCATION}/tagTemplates/data_product_information, --project_id=${PROJECT_ID},--location=${LOCATION},--lake_id=${LAKE_ID},--zone_id=${ZONE_ID},--entity_id=${ENTITY_ID},--input_file=${INPUT_YAML_FILENAME}"
        ```


## Creating the Data Product Quality Tag 

## Creating the Data Product Classification Tag 

## Creating the Data Product Exchange Tag



6. Create the tag templates in Data Catalog
   
7. Executing Templates

    The README files for each of the different templates have detailed instruction on how to use them. Please see the README.md file for the relevant section.

    The code can be executed locally as well as via custom tasks in Dataplex

**Service Account**:
A service account that has access to the DLP results table and access to create tags for the data entities.

# Development
Contributing
See the contributing instructions to get started contributing.

# Tag Analytics
Use the Open-Source module(TBD) to push the tag into BigQuery Table for reporting, analytics, monitoring, and auditing purposes.

# License
All solutions within this repository are provided under the Apache 2.0 license. Please see the LICENSE file for more detailed terms and conditions.

# Disclaimer
This repository and its contents are not an official Google Product.

# Contact
Questions, issues, and comments should be directed to
