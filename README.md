# golf-cart-rentals

[![Build Status](https://travis-ci.org/umts/golf-cart-rentals.svg?branch=master)](https://travis-ci.org/umts/golf-cart-rentals)
<a href="https://codeclimate.com/github/umts/golf-cart-rentals"><img src="https://codeclimate.com/github/umts/golf-cart-rentals/badges/gpa.svg" /></a>
<a href="https://codeclimate.com/github/umts/golf-cart-rentals/coverage"><img src="https://codeclimate.com/github/umts/golf-cart-rentals/badges/coverage.svg" /></a>

Gold Cart Rentals is a piece of web-based rental control software.

For instructions on setting up golf-cart-rentals, see the [Wiki](https://github.com/umts/golf-cart-rentals/wiki/Getting-Started-with-golf-cart-rentals!)

Items have multiple reservations, defining the days and user/department they are reserved for.
Items have 1 type, each type having its own associated fee schedule and agreement terms.
Users belong to 1 department, which will be invoiced for rentals.

Admin users can create, edit, and delete users, items, item types, departments, and handle individual user/group permissions.

The home page shows a view of the current users reservations, and can be used to view item availability and if the user is an admin, all existing reservations.

![Proposed table relationships](https://github.com/umts/golf-cart-rentals/blob/master/Golfcart%20Schema.png)
