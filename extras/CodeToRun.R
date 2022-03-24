library(EmcDementiaPredictionBase)
#=======================
# USER INPUTS
#=======================
# The folder where the study intermediate and result files will be written:
outputFolder <- "./EmcDementiaPredictionBaseResults"

connectionDetails <- DatabaseConnector::createConnectionDetails(
        dbms = "redshift",                                                                    
        server = "ohda-prod-1.cldcoxyrkflo.us-east-1.redshift.amazonaws.com/truven_ccae",
        port = 5439,
        user = "hjohn2",
        password = rstudioapi::askForPassword(),
        extraSettings="ssl=true&sslfactory=com.amazon.redshift.ssl.NonValidatingFactory",
        pathToDriver = "~/jdbcDrivers")

# Add the database containing the OMOP CDM data
cdmDatabaseSchema <- 'cdm_truven_ccae_v1831'
# Add a sharebale name for the database containing the OMOP CDM data
cdmDatabaseName <- 'CCAEv1831'
# Add a database with read/write access as this is where the cohorts will be generated
cohortDatabaseSchema <- 'scratch_hjohn2'

tempEmulationSchema <- NULL

# table name where the cohorts will be generated
cohortTable <- 'EmcDementiaPredictionBaseCohort'

# here we specify the databaseDetails using the 
# variables specified above
databaseDetails <- PatientLevelPrediction::createDatabaseDetails(
        connectionDetails = connectionDetails, 
        cdmDatabaseSchema = cdmDatabaseSchema, 
        cdmDatabaseName = cdmDatabaseName, 
        tempEmulationSchema = tempEmulationSchema, 
        cohortDatabaseSchema = cohortDatabaseSchema, 
        cohortTable = cohortTable, 
        outcomeDatabaseSchema = cohortDatabaseSchema,  
        outcomeTable = cohortTable, 
        cdmVersion = 5
)

# specify the level of logging 
logSettings <- PatientLevelPrediction::createLogSettings(
        verbosity = 'INFO', 
        logName = 'EmcDementiaPredictionBase'
)


#======================
# PICK THINGS TO EXECUTE
#=======================
# want to generate a study protocol? Set below to TRUE
createProtocol <- FALSE
# want to generate the cohorts for the study? Set below to TRUE
createCohorts <- TRUE
# want to run a diagnoston on the prediction and explore results? Set below to TRUE
runDiagnostic <- TRUE
viewDiagnostic <- FALSE
# want to run the prediction study? Set below to TRUE
runAnalyses <- FALSE
sampleSize <- 10000 # edit this to the number to sample if needed
# want to create a validation package with the developed models? Set below to TRUE
createValidationPackage <- FALSE
analysesToValidate = NULL
# want to package the results ready to share? Set below to TRUE
packageResults <- FALSE
# pick the minimum count that will be displayed if creating the shiny app, the validation package, the 
# diagnosis or packaging the results to share 
minCellCount= 5
# want to create a shiny app with the results to share online? Set below to TRUE
createShiny <- FALSE


#=======================

EmcDementiaPredictionBase::execute(
        databaseDetails = databaseDetails,
        outputFolder = outputFolder,
        createProtocol = createProtocol,
        createCohorts = createCohorts,
        runDiagnostic = runDiagnostic,
        viewDiagnostic = viewDiagnostic,
        runAnalyses = runAnalyses,
        createValidationPackage = createValidationPackage,
        analysesToValidate = analysesToValidate,
        packageResults = packageResults,
        minCellCount= minCellCount,
        logSettings = logSettings,
        sampleSize = sampleSize
)

# Uncomment and run the next line to see the shiny results:
# PatientLevelPrediction::viewMultiplePlp(outputFolder)
