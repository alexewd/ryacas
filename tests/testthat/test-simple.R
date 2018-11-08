context("Simple tests")

test_that("Sym", {
  xs <- Sym('xs')
  texp <- Taylor(exp(xs), xs, 0, 3)
  
  expect_equal(as.character(xs), "xs")
  expect_equal(class(xs), c("Sym", "character"))
  
  expect_equal(class(texp), c("Sym", "character"))
  expect_equal(as.expression(texp), expression(xs + xs^2/2 + xs^3/6 + 1))
  expect_equal(as.character(as.expression(texp)), "xs + xs^2/2 + xs^3/6 + 1")
  expect_equal(as.character(texp), "( Taylor( xs , 0 , 3 ) ( Exp ( xs ) ) )")
})

test_that("Expr", {
  x <- Sym("x")
  x3expr <- Expr(x*x*x)
  expect_equal(as.character(yacas(x3expr)), "x^3")
  expect_equal(Eval(x3expr, list(x = 2)), 8)
  #expect_equal(as.character(x3expr*x3expr), "x^6")
  #expect_equal(as.character(yacas(sin(x3expr))), "sin(x^3)")
})

test_that("TeXForm", {
  expect_equal(yacas("TeXForm(x*x)"), "$x ^{2}$")
  expect_equal(TeXForm(yacas("x*x")), "$x ^{2}$")
  
  expect_equal(yacas("TeXForm(x*x)", retclass = "unquote"), "$x ^{2}$")
  
  x <- Sym("x")
  expect_equal(TeXForm(x*x), "$x ^{2}$")
})

test_that("Yacmode", {
  expect_equal("Enter Yacas commands here. Type quit to return to R", 
               capture.output(
                 testthat::with_mock(
                   readline = function(x) { return("quit")}, yacmode())))
  
  ran_before <- FALSE
  expect_equal(c("Enter Yacas commands here. Type quit to return to R", 
                 "expression(x^3)"),
               capture.output(
                 testthat::with_mock(
                   readline = function(x) {
                     if (!ran_before) {
                       ran_before <<- TRUE
                       return("x*x*x")
                     }
                     return("quit")
                    }, yacmode())))
})