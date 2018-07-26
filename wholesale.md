\#\#To which clients should we sale in retail channels?
-------------------------------------------------------

Data Description:
-----------------

Wholesale Customer dataset refers to clients of a wholesale distributor. It includes the annual spending in monetary units (m.u.) on diverse product categories:

-   FRESH: annual spending (m.u.) on fresh products (Continuous)

-   MILK: annual spending (m.u.) on milk products (Continuous)

-   GROCERY: annual spending (m.u.)on grocery products (Continuous)

-   FROZEN: annual spending (m.u.)on frozen products (Continuous)

-   DETERGENTS\_PAPER: annual spending (m.u.) on detergents and paper products (Continuous)

-   DELICATESSEN: annual spending (m.u.)on and delicatessen products (Continuous)

-   CHANNEL: customersale Channel - Horeca (Hotel/Restaurant/Cafe) or Retail channel (Nominal)

-   REGION: customersale Region - Lisnon, Oporto or Other (Nominal)

------------------------------------------------------------------------

Objective:
----------

The major aim is to understand the relation between clients’ annual spending on product categories and their channel preference.

------------------------------------------------------------------------

Analysis and Exploring:
-----------------------

The logistic regression model showed that the relation between RETAIL Channels and DETERGENTS & PAPER, and GROCERY categories is highly positively significant, while it’s not significant with the other product categories.

*we should focus on selling these two categories via retail, Instead of focusing on all product categories.*

To check this conclusion: these two categories were used, instead of using all product categories, to rebuild the logistic regression model. This model has been used to predict the channel type of a new sample of clients.

![](wholesale_files/figure-markdown_github/plotting-1.png)

The previous figure shows how well the model performs. The dark green area represents the annual spending values on GROCERY and DETERGENT & PAPER products at which the model classified new clients as RETAIL clients, while at the dark red area the model classified clients as HORECA clients. The green and the red points represent the actual classification of RETAIL and HORECA clients respectively. As we see, it’s a high accurata classification.

*One could ask: Is it more profitable to depend on the the model than randomly sell to all clients via retail?*

confusion matrix shows that the model accurately predicted 32 out of 35 retail clients(the green sell) and 72 out of 74 horeca clients(white cell). On the other hand, inaccurately predicted 3 retail clients as horeca clients, and 2 horeca clients as retail clients(red cells).

| Predicted | RETAIL | HORECA |
|:----------|:-------|:-------|
| RETAIL    | 32     | 2      |
| HORECA    | 3      | 72     |
| RETAIL    | +$10   | -$1    |
| HORECA    | -$11   | -      |

As shown in the last two rows of the table, the average profit of selling to a client is $11, but there’s a $1 cost for using the retail channel. As a result, the profit of an accurate decision is $10. In addition to losses of $1 for using retail channel without actually selling, and $11 for ignoring possible retail client.

*Profit = $10 (32) -$1 (2) -$11 (3) = $285*

Randomly selling to all clients via retail means we successfully sell to the all 35 retail clients with a profit of $10, but unsuccessfully sell to the all 74 horeca clients with a cost of $0.5.

*Profit = $10 (34) -$1 (74) = $266*

------------------------------------------------------------------------

Conclusion:
-----------

Retail clients are more likely to consume more from detergent & paper and grocery Products. We could use these two product categories as variables to predict future retail clients. That was more profitable than randomly selling to all clients.
