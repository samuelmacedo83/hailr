### =========================================================================
### HailExpression objects
### -------------------------------------------------------------------------
###
### Expressions in the Hail language.
###

### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Classes
###

setClass("is.hail.expr.ir.BaseIR", contains="JavaObject")

setClass("HailExpression", contains=c("Expression", "VIRTUAL"))

.HailSymbol <- setClass("HailSymbol", contains="SimpleSymbol")

.HailI32 <- setClass("HailI32", slots=c(x="integer"),
                     contains="HailExpression")

.HailF64 <- setClass("HailF64", slots=c(x="numeric"),
                     contains="HailExpression")

.HailStr <- setClass("HailStr", slots=c(x="character"),
                     contains="HailExpression")

.HailFalse <- setClass("HailFalse", contains="HailExpression")
.HailTrue <- setClass("HailTrue", contains="HailExpression")

.HailNA <- setClass("HailNA", slots=c(type="HailType"),
                    contains="HailExpression")

.HailRef <- setClass("HailRef",
                     slots=c(symbol="HailSymbol"),
                     contains="HailExpression")

.HailApply <- setClass("HailApply",
                       slots=c(name="HailSymbol"),
                       contains=c("HailExpression", "SimpleCall"))

.HailGetField <- setClass("HailGetField",
                          slots=c(element="HailSymbol",
                                  container="HailExpression"),
                          contains="HailExpression")

.HailExpressionList <- setClass("HailExpressionList",
                                prototype=
                                    prototype(elementType="HailExpression"),
                                contains="SimpleList")

.HailSymbolList <- setClass("HailSymbolList",
                            prototype=
                                prototype(elementType="HailSymbol"),
                            contains="HailExpressionList")

setClassUnion("HailExpressionList_OR_NULL", c("HailExpressionList", "NULL"))

.HailVarArgs <- setClass("HailVarArgs", contains="HailExpressionList")

.HailMakeArray <- setClass("HailMakeArray",
                           slots=c(type="HailType", elements="HailVarArgs"),
                           contains="HailExpression")

.HailMakeStruct <- setClass("HailMakeStruct",
                            contains=c("HailExpression",
                                       "HailExpressionList"))

setClass("HailBinaryOp",
         slots=c(op="HailSymbol",
                 left="ANY", right="ANY"),
         contains=c("HailExpression", "VIRTUAL"))

.HailApplyComparisonOp <- setClass("HailApplyComparisonOp",
                                   contains="HailBinaryOp")

.HailApplyBinaryPrimOp <- setClass("HailApplyBinaryPrimOp",
                                   contains="HailBinaryOp")

.HailApplyUnaryPrimOp <- setClass("HailApplyUnaryPrimOp",
                                  slots=c(op="HailSymbol", x="ANY"),
                                  contains="HailExpression")

.HailArrayMap <- setClass("HailArrayMap",
                          slots=c(name="HailSymbol",
                                  array="HailExpression",
                                  body="HailExpression"),
                          contains="HailExpression")

.HailArrayFilter <- setClass("HailArrayFilter",
                             slots=c(name="HailSymbol",
                                     array="HailExpression",
                                     body="HailExpression"),
                             contains="HailExpression")

.HailArrayLen <- setClass("HailArrayLen",
                          slots=c(array="HailExpression"),
                          contains="HailExpression")

.HailIf <- setClass("HailIf",
                    slots=c(cond="HailExpression",
                            cnsq="HailExpression",
                            altr="HailExpression"),
                    contains="HailExpression")

.HailInsertFields <- setClass("HailInsertFields",
                              slots=c(old="HailExpression",
                                      field_order="NULL",
                                      fields="HailVarArgs"),
                              contains="HailExpression")

.HailSelectFields <- setClass("HailSelectFields",
                              slots=c(old="HailExpression",
                                      fields="HailSymbolList"),
                              contains="HailExpression")

.Accumulation <- setClass("Accumulation",
                          slots=c(op="character",
                                  constructor_args="HailExpressionList",
                                  init_op_args="HailExpressionList_OR_NULL",
                                  seq_op_args="HailExpressionList"))

.HailApplyScanOp <- setClass("HailApplyScanOp",
                             contains=c("Accumulation", "HailExpression"))

.HailApplyAggOp <- setClass("HailApplyAggOp",
                            contains=c("Accumulation", "HailExpression"))

### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Constructors
###

HailSymbol <- function(name) {
    .HailSymbol(name=name)
}

HailI32 <- function(x) {
    .HailI32(x=as.integer(x))
}

HailF64 <- function(x) {
    .HailF64(x=as.numeric(x))
}

HailStr <- function(x) {
    .HailStr(x=x)
}

HailFalse <- function() {
    .HailFalse()
}

HailTrue <- function() {
    .HailTrue()
}

HailNA <- function(x) {
    .HailNA(type=hailType(x))
}

HailRef <- function(symbol) {
    .HailRef(symbol=symbol)
}

HailApply <- function(name, args) {
    .HailApply(SimpleCall(as(name, "HailSymbol"), args))
}

HailGetField <- function(container, element) {
    .HailGetField(container=container, element=element)
}

HailExpressionList <- function(data = list()) {
    listData <- lapply(data, as, "HailExpression", strict=FALSE)
    .HailExpressionList(listData=listData)
}

HailVarArgs <- function(args) {
    .HailVarArgs(HailExpressionList(args))
}

HailMakeArray <- function(type, elements) {
    .HailMakeArray(type=type, elements=HailVarArgs(elements))
}

HailMakeStruct <- function(data) {
    .HailMakeStruct(HailExpressionList(data))
}

HailApplyComparisonOp <- function(op, left, right) {
    .HailApplyComparisonOp(op=op, left=left, right=right)
}

HailApplyBinaryPrimOp <- function(op, left, right) {
    .HailApplyBinaryPrimOp(op=op, left=left, right=right)
}

HailApplyUnaryPrimOp <- function(op, x) {
    .HailApplyUnaryPrimOp(op=op, x=x)
}

HailArrayMap <- function(name, array, body) {
    .HailArrayMap(name=name, array=array, body=body)
}

HailArrayFilter <- function(name, array, body) {
    .HailArrayFilter(name=name, array=array, body=body)
}

HailArrayLen <- function(array) {
    .HailArrayLen(array=array)
}

HailIf <- function(cond, cnsq, altr) {
    .HailIf(cond=cond, cnsq=cnsq, altr=altr)
}

HailInsertFields <- function(old, fields) {
    ### TODO: optimize by coalescing previous InsertFields
    .HailInsertFields(old=old, fields=HailVarArgs(fields))
}

HailSelectFields <- function(old, fields) {
    ### TODO: optimize by coalescing previous Select()
    ### TODO: optimize by coalescing InsertFields (drop the unneeded ones)
    .HailSelectFields(old=old, fields=fields)
}

Accumulation <- function(op, constructor_args = HailExpressionList(),
                         init_op_args = NULL,
                         seq_op_args = HailExpressionList())
{
    .Accumulation(op=op, constructor_args=constructor_args,
                  init_op_args=init_op_args, seq_op_args=seq_op_args)
}

HailApplyScanOp <- function(accumulation) {
    .HailApplyScanOp(accumulation)
}

HailApplyAggOp <- function(accumulation) {
    .HailApplyAggOp(accumulation)
}

### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Accessors
###

setMethod("$", "HailExpression", function(x, name) x[[name]])

setMethod("[[", "HailExpression", function(x, i, j, ...) {
    stopifnot(missing(j), missing(...), isSingleString(i))
    HailGetField(x, HailSymbol(i))
})

setMethod("[[", "HailMakeStruct", function(x, i, j, ...) {
    stopifnot(missing(j), missing(...))
    as.list(x)[[i]]
})

symbol <- function(x) x@symbol

### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Type inference
###

setMethod("hailType", "HailNA", function(x) x@type)
setMethod("hailType", "HailMakeArray", function(x) x@type)
setMethod("hailType", "HailGetField",
          function(x) hailType(x@container)[[name(x@element)]])

### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### Coercion
###

hailLiteral <- function(from, CONSTRUCTOR) {
    stopifnot(length(from) == 1L)
    if (is.na(from))
        HailNA(from)
    else CONSTRUCTOR(from)
}

setAs("character", "HailExpression", function(from) {
    hailLiteral(from, HailStr)
})

setAs("integer", "HailExpression", function(from) {
    hailLiteral(from, HailI32)
})

setAs("numeric", "HailExpression", function(from) {
    hailLiteral(from, HailF64)
})

setAs("logical", "HailExpression", function(from) {
    hailLiteral(from, function(from) {
        if (from)
            HailTrue()
        else HailFalse()
    })
})

setAs("list", "HailExpression", function(from) {
    stopifnot(length(from) == 1L)
    HailMakeArray(hailType(from),
                  lapply(from[[1L]], as, "HailExpression"))
})

ir_name <- function(x) sub("^Hail", "", class(x))

setGeneric("to_ir", function(x, ...) as.character(x))

setMethod("to_ir", "HailSymbol", function(x, ...) escape_id(name(x)))

setMethod("to_ir", "HailExpression",
          function(x, ...) to_ir(c(ir_name(x), ir_args(x)), ...))

setMethod("to_ir", "list",
          function(x, ...) paste0("(",
                                  paste(vapply(x, to_ir, character(1L), ...),
                                        collapse=" "),
                                  ")"))

setMethod("to_ir", "List", function(x, ...) to_ir(as.list(x), ...))

setMethod("to_ir", "HailVarArgs",
          function(x, ...) {
              if (is.character(names(x)))
                  x <- mapply(list, lapply(names(x), HailSymbol), x)
              paste(vapply(x, to_ir, character(1L), ...),
                    collapse=" ")
          })

setMethod("to_ir", "NULL", function(x, ...) "None")

setMethod("to_ir", "logical", function(x, ...) {
    stopifnot(isTRUEorFALSE(x))
    if (x) "True" else "False"
})

setGeneric("ir_args", function(x) standardGeneric("ir_args"))

setMethod("ir_args", "HailExpression",
          function(x) setNames(lapply(slotNames(x), slot, object=x),
                               slotNames(x)))

setMethod("ir_args", "HailApply", function(x) c(x@name, x@args))

setMethod("ir_args", "HailMakeStruct",
          function(x) as.list(zipup(Pairs(names(x), as.list(x)))))

setMethod("ir_args", "HailStr", function(x) list(paste0("\"", x@x, "\"")))

escape_id <- function(x) {
    underscored <- startsWith(x, "_")
    if (underscored) {
        x <- paste0("x", x)
    }
    ans <- capture.output(print(as.name(x)))
    if (underscored) {
        ans <- substring(x, 2L)
    } else if (startsWith(ans, ".")) {
        ans <- paste0("`", ans, "`")
    }
    ans
}

setMethod("as.character", "HailExpression", function(x) to_ir(x))

setAs("character", "HailSymbol", function(from) HailSymbol(from))

### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
### show()
###

setMethod("show", "HailExpression",
          function(object) cat(as.character(object), "\n"))
