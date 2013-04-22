#! /bin/bash

mkdir -vp /var/qmail
mkdir -vp /var/qmail/alias

addgroup --system nofiles
addgroup --system qmail

adduser --system --home /var/qmail/alias/ --shell /bin/false --no-create-home --ingroup nofiles alias
adduser --system --home /var/qmail/ --shell /bin/false --no-create-home --ingroup nofiles qmaild
adduser --system --home /var/qmail/ --shell /bin/false --no-create-home --ingroup nofiles qmaill
adduser --system --home /var/qmail/ --shell /bin/false --no-create-home --ingroup nofiles qmailp
adduser --system --home /var/qmail/ --shell /bin/false --no-create-home --ingroup qmail qmailq
adduser --system --home /var/qmail/ --shell /bin/false --no-create-home --ingroup qmail qmailr
adduser --system --home /var/qmail/ --shell /bin/false --no-create-home --ingroup qmail qmails

