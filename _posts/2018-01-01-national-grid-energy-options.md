---
title: "Should I switch National Grid energy provider? (NY State)"
author: "Luke Winslow"
date: "January 1, 2018"
output: html_document
---

Ever since I moved to New York state (Troy, NY area), I have been hounded by a troubling question. Should I switch 
my energy provider? 

In NY state, we have "[Energy Choices](http://www3.dps.ny.gov/W/PSCWeb.nsf/All/52770E53410005A185257687006F39D2?OpenDocument)". 
This means you can pick from a list of certified providers and get your gas or electric supply from *them*, not your main utility. 
Your main utility (National Grid in my case) will still deliver your energy, with associated, non-negotiable costs.

If you've ever looked into switching energy providers, you've probably figured out its difficult. Total pain in the ass. 
But duringt the holiday break, I finally decided to dig into things. 


## TL; DR: 

Don't switch energy providers in NY. Read the fine print. Do the math. It probably doesn't pay, and you might end up paying more 
without noticing. They are all selling what seems to be the same wholesale energy, with added gimmics that might
make it seem cheaper. 

## Alternative provider price discovery

My first stab at this was to just find a price comparison website. This is a challenge, 
as a bunch out there seem pretty crappy, biased, and potentially run by the providers themselves. 
The sites rarely include the basic National Grid price in with the comparison. I won't even
link to them to give them the google credit. 

Then I found one of the few good ones for NY state. [NYS Power To Choose](http://documents.dps.ny.gov/PTC/home). 
Made by the NY Public Service Commission. My search looks like this:

![NY Public Service Comission Website Query](/images/nps_query_electric.PNG)

## When is a rate not a rate?

Without digging into it too much, there seem to be several rates provided by alternative energy providers
that are better than my National Grid rate. Agway has a really cheap variable rate, and City Power & Gas
has a 12-month fixed rate that is lower than the current National Grid rate (not shown in screenshot, $0.0517/kWh). 

But there are two critical issues here. 

* The National Grid number shown is just the variable rate for this month. It isn't a representative average. 

* The Agway rate is not a true rate, when you click on "prior offers", you see Agway only shows Promotional rates. 

So I'm very skeptical of the Agway rate. All rates listed on that website are introductory rates. So I have no visibility
into the true rates after my introductory month is over. The same goes for Columbia Utilities Power, LLC rate. There are a 
bunch of other tricks played by the variable rate game. Many have large cancellation fees (~$100) that would quickly negate
any savings I might get from them (if there were any) in the event I cancel. 

Fixed rates have some potential, but need to be compared with a longer-term outlook on my own rate. National Grid rate is
variable, so I decided to dig into what my effective fixed rate for the past year was. 

## My average rate
I pulled up all my past electric bills. Here is the resulting table 
([google doc link](https://docs.google.com/spreadsheets/d/1kKVvXd66XKA8x0gL838_UMGzblF4t33p5pDUP2T0HCA/edit?usp=sharing)), 
with weighted averages of gas and electric rates.
(I looked at both, but just focus on electric rate here). The result? I paied a weighted average of $0.045 per kWh. 
This is definitely lower than the lowest fixed rate provider available to me. 


![My personal energy rate](/images/energy_rate_table.PNG)

Of course, one is forward-looking (fixed rate) and the other is backward looking (my historical rates). 
But its one of the better comparisons available to me at at the moment.

## Conclusion

I am not switching anytime soon. My quick estimate, and the articles listed below, suggest that through 
the complex financials of these alternative providers, *most* people end up paying more for their energy. I 
have already personally seen someone paying *far* more than they should for energy after not reading the 
fine print on their energy provider. 

The only energy providers that may offer any cost benefit are those that guarantee 
a rate which matches the utility rate, plus some sort of discount (I have seen 1% and 5%). But I will be super 
careful about the terms, which, I suspect, make it difficult to collect on that guarantee, or make it easy to
not quality. 

## Other external evidence

Articles on this issue were surprisingly hard to find. But there are a few with what seem like fairly damning numbers. 

 * [National Grid households pay extra when they buy energy from outside marketers](http://www.syracuse.com/news/index.ssf/2012/09/national_grid_customers_pay_ex.html)
 
 * [Most customers who switch from National Grid pay more](http://www.syracuse.com/news/index.ssf/2012/09/post_670.html)

 * [Customers compare ESCO bills to National Grid: One loses $100 a month, another saves $30](http://www.syracuse.com/news/index.ssf/2013/07/winners_and_losers_customers_compare_esco_bills_to_national_grid.html)*

 * [Save Money by Switching Your Electricity or Gas Supplier? Think Twice.](http://utilityproject.org/campaigns/save-money-by-switching-your-electricity-or-gas-supplier-think-twice/)
 
 * [Time is Money: AARP Urges NYers to Reject ESCOs; End to Delay in Probe of High Prices](http://utilityproject.org/2017/07/07/time-is-money-aarp-urges-nyers-to-reject-escos-end-to-delay-in-probe-of-high-prices/)

\* I find the UPS driver story in this article to be BS. Viridian Energy basically operates a pyramid scheme, where you 
try to get your friends and family to switch, and they pay you for energy they buy. Someone is paying for your savings, 
and it would probably be your friends/family/grandma. There's no indication that their base-rates are cheaper.
