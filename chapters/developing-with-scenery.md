# Developing with _scenery_



In this chapter, we describe how to develop prototypes and applications with scenery. For that we're first going to introduce the principles of _Iterative Design_.

With scenery, we aim to give both developers and users a tool which can help them design new visualisations for their biological data with ease. While creating scenery took now the better part of two years, creating a new visualisation, demo, or entire application with it is usually a matter of minutes for the first prototype.

## Define, Make, Learn — Principles of Iterative Design

In [@Jerald:2015vk], Jerald argues that Iterative Design is the ideal paradigm for designing Virtual Reality applications, as — opposed to regular user interface design — there are no "golden rules" (yet), and a lot has to be discovered throughout the design process. He also argues for "accidental discoveries" during the design process, discoveries that would not happen if Iterative Design would not have been applied.

Following Jerald, we can define three distinct phases in the Iterative Design process:

1. _Define_ — The planning phase, includes everything from "what are we actually trying to achieve?", to a list of requirements for the final visualisation/demo/application.
2. _Make_ — In this phase, we're trying to answer the question of "how are we going to do that?", and bring the result into practise.
3. _Learn_ — In the final phase, we're analysing what works and what doesn't, feeding that information back into the _Define_ stage, continuing with the cycle.

Although, why go through that trouble? Nielsen [@Nielsen:kq] introduces an example,

> "The user interface to a computer security application was tested and improved through three versions as discussed further below. A lower bound estimate of the value of the user interface improvements comes from calculating the time saved by users because of the shorter task completion times, thus leaving out any value of the other improvements. The number of users of the security application was 22,876 and each of them could be expected to save 4.67 minutes from using version three rather than version one for their first twelve tasks (corresponding to one day's use of the system), for a total time savings of 1,781 work hours. Karat estimates that this corresponds to saved personnel costs of $41,700 which compares very favorably with the increased development costs of only $20,700 due to the iterative design process. The true savings are likely to be considerably larger since the improved interface was also faster after the first day."

Furthermore, Nielsen introduces[@Nielsen:kq] several case studies, coming to the conclusion that the median improvement from first to last version in the case studies was 165%. An idealisation of how the iteration might influence the usability of the final application is shown in Figure \ref{fig:NielsenUsability}.

\begin{marginfigure}
    \label{fig:NielsenUsability}
    \includegraphics{nielsen-iterative-improvements.png}
    \caption{Usability as a function of iterations. From \citep{Nielsen:kq}.}  
\end{marginfigure}

From the other direction, Brooks argues [@Brooks:2010wb] that up-front design can very easily lead to building overly complex, expensive systems, that might even fail to hit the user's need. Wingrave and LaViola [@Wingrave:wx] argue that in the context of virtual reality systems, iteration is much more important that for non-VR systems, as the possibilities of virtual reality reach beyond regular reality, with also more human factors coming into play. Iterative Design can help to bring ideas to fruition quicker than other approaches, as ideas can be quickly tested and iterated on.

After this quick intro, let's go into detail about these phases, and learn how we can make use of them when creating scenery-based applications.

### Define

### Make

### Learn

## Case studies and Iterative Design

In the following part, we are going to introduce a few case studies we have developed using scenery. These case studies are:

* _SciView_, a Fiji plugin hooking scenery into the ImageJ ecosystem and providing a end-user frontend for scenery while not limiting the exposed functionality,
* _Attentive Tracking_, an alternative user interface to solve tracking and tracing problems by eye tracking,
* _Rendering the Adaptive Particle Representation_, introducing the _Adaptive Particle Representation_, an compute/memory-efficient image representation tailored to fluorescence images, and showing how we integrated it with scenery, developing multiple rendering modalities along the way, and
* _Interactive Laser Ablation_, showcasing the development of a Virtual Reality-based user interface to perform laser-based microsurgery in microscopic specimen.

With the exception of _SciView_, we have applied Iterative Design throughout the development process, and the respective chapters will follow the aforementioned structure.



