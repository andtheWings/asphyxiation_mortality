box::use(
    parsnip[
        set_dependency,
        set_encoding,
        set_fit,
        set_model_arg,
        set_model_engine, 
        set_model_mode, 
        set_new_model,
        set_pred,
        show_model_info
    ]
)

box::use(parsnip[])

set_new_model("neg_binom_reg")
set_model_mode(model = "neg_binom_reg", mode = "regression")

# Using glm engine

set_model_engine(
    "neg_binom_reg", 
    mode = "regression", 
    eng = "glm"
)
set_dependency(
    "neg_binom_reg", 
    eng = "glm", 
    pkg = "MASS"
)

neg_binom_reg <- function(mode = "regression") {
    box::use(
        parsnip[new_model_spec],
        rlang[abort]
    )
    
    # Check for correct mode
    if (mode  != "regression") {
        abort("`mode` should be 'regression'")
    }
    
    args <- list()
    
    # Save some empty slots for future parts of the specification
    new_model_spec(
        "neg_binom_reg",
        args = args,
        eng_args = NULL,
        mode = mode,
        method = NULL,
        engine = NULL
    )
}

set_fit(
    model = "neg_binom_reg",
    eng = "glm",
    mode = "regression",
    value = list(
        interface = "formula",
        protect = c("formula", "data"),
        func = c(pkg = "MASS", fun = "glm.nb"),
        defaults = list()
    )
)

set_encoding(
    model = "neg_binom_reg",
    eng = "glm",
    mode = "regression",
    options = list(
        predictor_indicators = "traditional",
        compute_intercept = TRUE,
        remove_intercept = TRUE,
        allow_sparse_x = FALSE
    )
)

show_model_info("neg_binom_reg")



