#' Take a model object for a count outcome and format it to feed into VCS package's rootogram function to visualize accuracy of fit
#' @export
make_rootogram <- function(model) {
    # Load needed modules
    box::use(
        dplyr[group_by, n, pull, summarize],
        magrittr[`%>%`],
        tibble[as_tibble],
        vcd[rootogram]
    )
    
    # Operations for a glm-generated object
    if(any(class(model) %in% "glm")){
        predictions <- 
            # Pull predictions from the object and round them to closest integer
            as_tibble(round(model$fitted.values)) %>%
            # Group by each count
            group_by(value) %>%
            # Determine frequency of each count
            summarize(n = n()) %>%
            # Convert to named vector
            pull("n")
        # Pull observations from the object
        observations <-
            model$y
        # Operations for a tidymodels generated object
    } else if(any(class(model) %in% "tbl_df")) {
        predictions <-
            # Pull predictions from the object and rount them to closest integer
            as_tibble(round(model$.pred)) %>%
            # Group by each count
            group_by(value) %>%
            # Determine frequency of each count
            summarize(n = n()) %>%
            # Convert to named vector
            pull("n")
        # Pull observations from the object
        observations <- model$.obs
    }
    
    # Check if prediction and observation vectors are of same length
    diff <- length(table(observations)) - length(predictions)
    print(diff)
    
    # Operations if there is discrepancy in vector lengths
    if(diff > 0){
        # Add dummy frequnecies of 0 to make the vectors the same length
        predictions <- c(predictions, rep(0, diff))
    }
    
    # Feed into the rootogram and return visualization
    return(
        rootogram(
            table(observations), 
            predictions
        )
    )
}