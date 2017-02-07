# prog_prove_opt.m4 - check if prove accepts command line option
#
# Copyright (c) 2013 Piotr Roszatycki <dexter@debian.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.

# _AS_VAR_APPEND_PREPARE
# ----------------------
# Define as_fn_append to the optimum definition for the current
# shell (bash and zsh provide the += assignment operator to avoid
# quadratic append growth over repeated appends).
m4_defun([_AS_VAR_APPEND_PREPARE],
[AS_FUNCTION_DESCRIBE([as_fn_append], [VAR VALUE],
[Append the text in VALUE to the end of the definition contained in
VAR.  Take advantage of any shell optimizations that allow amortized
linear growth over repeated appends, instead of the typical quadratic
growth present in naive implementations.])
AS_IF([_AS_RUN(["AS_ESCAPE(m4_quote(_AS_VAR_APPEND_WORKS))"])],
[eval 'as_fn_append ()
  {
    eval $[]1+=\$[]2
  }'],
[as_fn_append ()
  {
    eval $[]1=\$$[]1\$[]2
  }]) # as_fn_append
])

# _AS_VAR_APPEND_WORKS
# --------------------
# Output a shell test to discover whether += works.
m4_define([_AS_VAR_APPEND_WORKS],
[as_var=1; as_var+=2; test x$as_var = x12])

# AS_VAR_APPEND(VAR, VALUE)
# -------------------------
# Append the shell expansion of VALUE to the end of the existing
# contents of the polymorphic shell variable VAR, taking advantage of
# any shell optimizations that allow repeated appends to result in
# amortized linear scaling rather than quadratic behavior.  This macro
# is not worth the overhead unless the expected final size of the
# contents of VAR outweigh the typical VALUE size of repeated appends.
# Note that unlike AS_VAR_SET, VALUE must be properly quoted to avoid
# field splitting and file name expansion.
m4_defun_init([AS_VAR_APPEND],
[AS_REQUIRE([_AS_VAR_APPEND_PREPARE], [], [M4SH-INIT-FN])],
[as_fn_append $1 $2])


# ACX_PROG_PROVE_OPT([OPTS], [BODY], [ON-FALSE])
# ----------------------------------------------
AC_DEFUN([ACX_PROG_PROVE_OPT],
    [m4_define([myname], [PROVE_HAVE_OPT_$1])
        AC_CHECK_PROGS([PROVE], [prove])
        AS_VAR_PUSHDEF([acx_var], [acx_cv_prog_prove_opt_$1])
        AC_CACHE_CHECK([whether $PROVE accepts $1],
            acx_var,
            [_ACX_PROG_PROVE_TRY([$1], [$2],
                [AS_VAR_SET(acx_var, [yes])], [AS_VAR_SET(acx_var, [no])])])
        AS_VAR_IF(acx_var, [yes],
            [AS_VAR_APPEND([PROVEFLAGS], [" $1"])
                AC_SUBST([PROVEFLAGS])
                AC_SUBST(AS_TR_CPP(myname), [true])
                AS_VAR_SET(acx_var, [yes])],
            [$3])
        AS_VAR_POPDEF([acx_var])
        m4_undefine([myname])])

# _ACX_LANG_CONFTEST_PL([BODY])
# -----------------------------
m4_define([_ACX_LANG_CONFTEST_PL],
[cat <<_ACEOF >conftest.pl
$1
_ACEOF])

# _ACX_PROG_PROVE_TRY([OPTS], [BODY], [IF-WORKS], [IF-NOT])
# ---------------------------------------------------------
m4_define([_ACX_PROG_PROVE_TRY],
    [_ACX_LANG_CONFTEST_PL(m4_default([$2], [
printf "1..1\n";
printf "ok 1\n";
exit 0;
]))
        ac_try='$PROVE $1 conftest.pl >&AS_MESSAGE_LOG_FD'
        AS_IF([_AC_DO_VAR(ac_try)], [$3], [$4])])
