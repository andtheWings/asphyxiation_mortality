summarize_rootogram_table <- function(sids_df, lm_model, nb_model) {
    
    lm_rootogram <-
        as_tibble(lm_model$fitted.values) |> 
        mutate(
            value = 
                case_when(
                    value < 0.5 ~ 0,
                    value >= 0.5 & value < 1.5 ~ 1,
                    value >= 1.5 & value < 2.5 ~ 2,
                    value >= 2.5 & value < 3.5 ~ 3,
                    value >= 3.5 & value < 4.5 ~ 4,
                    value >= 4.5 & value < 5.5 ~ 5,
                    value >= 5.5 ~ 6
                )
        ) |> 
        group_by(value) |> 
        summarize(
            lm_expected = sqrt(n())
        ) |> 
        add_row(
            value = 3:6,
            lm_expected = c(0, 0, 0, 0)
        )
    
    nb_rootogram <- 
        topmodels::rootogram(
            nb_model,
            plot = FALSE
        ) |> 
        select(-observed, -width) |> 
        rename(nb_expected = expected)
    
    df1 <-
        sids_df |> 
        group_by(sids_count) |> 
        summarize(
            sqrt_sids_count = sqrt(n())
        ) |> 
        left_join(
            lm_rootogram,
            by = c("sids_count" = "value")
        ) |> 
        left_join(
            nb_rootogram,
            by = c("sids_count" = "mid")
        )
    
    return(df1)
    
}


# {vcd} method
#' #' Take a model object for a count outcome and format it to feed into VCS package's rootogram function to visualize accuracy of fit
#' #' @export
#' make_rootogram <- function(model) {
#'     # Load needed modules
#'     box::use(
#'         vcd[rootogram]
#'     )
#'     
#'     # Operations for a glm-generated object
#'     if(any(class(model) %in% c("negbin", "zeroinfl"))){
#'         predictions <- 
#'             # Pull predictions from the object and round them to closest integer
#'             as_tibble(round(model$fitted.values)) |>
#'             # Group by each count
#'             group_by(value) |>
#'             # Determine frequency of each count
#'             summarize(n = n()) |>
#'             # Convert to named vector
#'             pull("n")
#'         # Pull observations from the object
#'         observations <-
#'             model$y
#'         
#'     # Operations for a tidymodels generated object
#'     } else if(any(class(model) %in% "tbl_df")) {
#'         predictions <-
#'             # Pull predictions from the object and round them to closest integer
#'             as_tibble(round(model$.pred)) |>
#'             # Group by each count
#'             group_by(value) |>
#'             # Determine frequency of each count
#'             summarize(n = n()) |>
#'             # Convert to named vector
#'             pull("n")
#'         # Pull observations from the object
#'         observations <- model$.obs
#'     }
#'     
#'     # Check if prediction and observation vectors are of same length
#'     diff <- length(table(observations)) - length(predictions)
#'     print(diff)
#'     
#'     # Operations if there is discrepancy in vector lengths
#'     if(diff > 0){
#'         # Add dummy frequnecies of 0 to make the vectors the same length
#'         predictions <- c(predictions, rep(0, diff))
#'     }
#'     
#'     # Feed into the rootogram and return visualization
#'     return(
#'         rootogram(
#'             table(observations), 
#'             predictions
#'         )
#'     )
#' }