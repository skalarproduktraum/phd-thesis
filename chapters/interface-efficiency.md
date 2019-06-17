# Quantifying Interface Efficiency

The efficiency of Human-Computer Interfaces can be measured in various ways, such as watching different types of users — unexperienced vs. experienced — use a specific interface and evaluating their actions subjectively, or by trying to come up with a mathematical model of how the user will interact a specific interface. In this chapter we are going to explore the latter possibility, in the form of an extension of the widely-used and validated Keystroke-Level Model (KLM). We start with an introduction to the original model, and example calculations for two interfaces achieving the same task.

## The Keystroke-Level Model for Quantifying Interface Efficiency

A widely used model for quantification the efficiency of an interface is a model based on defining \textbf{G}oals, a set of \textbf{O}perators used as instruments, a set of \textbf{M}ethods to achieve the defined Goals, and a definition of \textbf{S}election rules how to discern competing methods, in short _GOMS_. The GOMS model, or it's original version, _CMN-GOMS_, the  was introduced in 1980 by Card, Moran, and Newell [@Card:1980kl] and can help to predict the time taken by an experienced user to perform a given task. It soon turned out it was relatively difficult to build a CMN-GOMS-based predictor, and the authors published a highly simplified version of it, the _Keystroke-Level Model_ (KLM) [@Card:1980kl].

The main benefit of the original KLM-GOMS model is that it is simple and easy to evaluate, and — despite making assumptions about the average time taken for different parts of a task's execution — it is quite accurate in addition. Since its inception has been widely used, e.g. for \TODO{add example papers}. The major downside of the model is not taking other aspects of the user's performance into consideration: already the original authors acknowledge not taking into account factors like fatigue, learning, or errors made during execution [@Card:1980kl]. As mentioned above, the model also assumes an experienced user, and as such cannot be applied to the unskilled user.

Since the development of the original model, more derivatives were developed such as, 

* _CPM-GOMS_ [@John:1995cp], extending the original GOMS model to parallel tasks, 
* _Codein_ [@Christou:2012b12], a new notation for GOMS which extends to reality-based interfaces,
* the _Touch-Level Model_ (TLM) [@Rice:2014341], which not only extends the use of KLM-GOMS to today's ubiquitous touch-enabled devices, but also introduces new operators, e.g. for taps, gestures, or real-world distractions, or
* the _Touch-less Hand Gesture-Level Model_ (THGLM), extending the KLM to touchless interactions [@Erazo:2015d6c].

### KLM-GOMS Concepts and Terminology

KLM-GOMS reduces the complexity of the CMN-GOMS model to having only keystrokes as _Method_ to achieve a _Unit Task_ — "a small, cognitively manageable, quasi-independent task" [@Card:1980kl].

The execution of tasks then is described using four operators for physical interaction (_Keystroking_, _Pointing_, _Homing_, and _Drawing_), one _Mental_ operator, and one _Response_ operator. The model defines the total execution time $T$ of a task as

\begin{align}
T = T_K + T_P + T_H + T_D + T_M + T_R.
\end{align}

Keystrokes are assumed to be the most frequently used interactions, and _Pointing_ operations are assumed to be executed with a mouse. According to _Fitts's Law_ [@Fitts:1954135], the time it takes a user to move the mouse to a target of size $s$ over a distance $d$ with a mouse[^FittsNote] is

\begin{align}
T_P = 0.8 + 0.1 \ln\left(\frac{d}{s} + 0.5 \right)\,\mathrm{s}.
\end{align}

Following Fitt's Law, the best possible time here is $0.8\,\mathrm{s}$, while the worst would be $1.5\,\mathrm{s}$. To keep the model simple, the authors use a constant time, the average of both, $1.1\,\mathrm{s}$.

Further execution times for the operators according to [@Card:1980kl] are given in Table \ref{tbl:GOMSExecutionTimes}.

| Operator | Description | Time/s |
|:--|:--|:--|
| \textbf{K}eystroke | Pressing a key, including modifiers. | $0.08 - 1.20$, $0.2$ avg. |
| \textbf{P}ointing | Pointing to a target, subject to Fitt's Law | $1.1$ |
| \textbf{H}oming | Homing the hands on an input device. | $0.4$ |
| \textbf{D}rawing | Drawing $n$ line segments of length $l$ | $0.9n + 0.16l$ |
| \textbf{M}ental | Mentally preparing a physical action. | $1.35$ |
| \textbf{R}esponse | Time $t$ the user has to wait for the system to respond. | t |

Table: Execution times for the KLM-GOMS operators. {#tbl:GOMSExecutionTimes}

[^FittsNote]: The given expression only applies to 1D mouse movements. The constants $a$ and $b$ of the general form of Fitts's Law, $T = a + b \cdot \ln\left(\frac{d}{s}+0.5\right)$ have to be determined experimentally for other cases. Fitts's Law has also been extended to three-dimensional pointing tasks [@Murata:2001ebc].

After putting together the operators for the task under evaluation, a set of heuristics needs to be applied for distributing the Mental operators correctly (following [@Card:1980kl] and [@Raskin:2000thi]):

1. Place Ms in front of all Ks that are not part of an argument. Place Ms in front of all Ps that select commands, but not arguments.
2. Delete an M if it is _fully anticipated_, e.g. if a P is followed by a K for e.g. clicking a button, there will be no M in between. (PMK becomes PK).
3. If a string of MKs belongs to a _cognitive unit_, delete all Ms but the first (such as when typing the name of a command, or any of its arguments).
4. If a K is a redundant delimiter, e.g. terminating a command immediately following the terminator of its argument, delete the M before it.
5. If a K terminates a _constant string_, such as a command name, delete the M before it. If the string is not constant, such as in an argument, do not delete the M.
6. Delete any Ms that overlap an R.

While these six heuristics may seem arbitrary at first glance, they have a deeper rooting in cognitive psychology — _chunking_: Performing an additional keystroke action (like pressing the \keys{\return} key), e.g. to confirm a selection or end a command, does not cost the user additional mental effort, and as usage proficiency grows, will be assimilated into entering the command. This "package" is called a chunk. A user therefore does not mentally prepare for just the next operation, but for a chunk of them [@Card:1980kl].

### An Example KLM-GOMS Calculation

_The discussion in this section follows chapter 4.2.3 of [@Raskin:2000thi]_

\begin{marginfigure}
    \includegraphics{./figures/laser-power-interfaces.pdf}
    \caption{Two examples of how interfaces for adjusting laser power on a microscope could be designed. See text for theoretical comparison. \label{fig:LaserPowerInterfaces}}
\end{marginfigure}

Let's make an example calculation to compare the efficiency of two interfaces with each other: In Figure \{ref:LaserPowerInterfaces} we show two examples of how an interface for adjusting the laser power on a microscope could be adjusted by the user:

* In __A__, the user can type in the wanted laser power, followed by pressing the _Set_ button. Alternatively, the user can adjust the power by pushing the spinner buttons, while
* in __B__, a range of laser powers — as biological specimen have only a certain tolerance before phototoxicity arises, this can be used as a guideline — is shown on a slider. The user can adjust the ranges of the slider by clicking on the buttons above and below, adjusting the range. By dragging the slider, the laser power can be set. 

In the case of using the spinner controls of __A__, the following steps are necessary:

* _H_ move hand to input device,
* _P_ point input device to the input field,
* 3 _K_ to type in the laser power with three significant digits,
* _P_ point input device to the _Set_ button
* _K_ click the _Set_ button, ending up with

_HPKKKPK_. Adding the necessary mental operators according to Rule 1, we get _HMPKMKMKMPK_. As the _K_ operators for the laser power are fully anticipated though, we delete the _M_ operators except for the first one in that string according to rule 3, and arrive at _HMPKKKMPK_. For the execution time $T$, we get

\begin{align}
T & = T_H + T_M + T_P + 3 \cdot T_K + T_M + T_P + T_K \\
& = T_H + 2 \cdot T_M + 4 \cdot T_K + 2 \cdot T_P \\
 & = 0.4 + 2 \cdot 1.35 + 4 \cdot 0.2 + 2 \cdot 1.1\\
 & = 6.1\,\mathrm{s}.
\end{align}

In design __B__, we followed a more skeuomorphic way of designing the interface, which means that the interfaces resembles a slider that could be present on a physical device in hardware. The necessary steps to set up a given laser power are (the calculation here is assumed to be worst case, where the ranges do not match the wanted power):

* _H_ move hand to input device,
* _P_ point input device to the top scroll button,
* _K_ push down button on mouse on top scroll button,
* _S_ scroll until desired maximum is shown,
* _P_ point input device to the bottom scroll button,
* _K_ push down button on mouse on bottom scroll button,
* _S_ scroll until desired minimum is shown,
* _P_ point input device to the slider,
* _K_ push down button on slider,
* _P_ point slider to desired power value, and
* _K_ release mouse button,

_HPKSPKSPKPK_. Adding _M_ according to Rules 1 and 2, we get _HMPKSMPKSMPKPK_. For the scroll action _S_ we assume a time of 2 seconds, in accordance with [@Raskin:2000thi]. For the execution time $T$, we arrive at

\begin{align}
T & = T_H + 2\cdot (T_M + T_P + T_K + T_S) + T_M + 2\cdot(T_P + T_K)\\
& = 0.4 + 2\cdot (1.35 + 1.1 + 0.2 + 2.0) + 1.35 + 2\cdot(1.1 + 0.2)\\
 & = 13.65\,\mathrm{s}.
\end{align}

We can see that the interface design _A_, which enables the user to just type in and confirm the desired laser power, is clearly superior from a execution time point of view. 

[@Raskin:2000thi] also discusses the ideal interface, which in our case would end up with _MKKK_, the mental operation plus three key strokes for typing the temperature, resulting in an execution time of only $1.95\,\mathrm{s}$. While clearly optimal, in our use case such an interface is not desirable: the user needs to be able to confirm the setting, such that typos are avoided. In design __A__, this is implemented by the _Set_ button, while in design __B__ the laser power is only set after the user has finished dragging the slider. 

## An Extension of the Keystroke-Level Model for Virtual Reality

As mentioned in the introduction above, the KLM has been extended to include other interfaces than just keyboards, such as touchscreen interfaces or interfaces based on touchless gestural interaction [@Erazo:2015d6c]. In this section we construct a KLM-derived model that extends the work of [@Erazo:2015d6c] to virtual reality and augmented reality settings, where the user can use both free-hand interaction and  physical controllers, and might perform gestures with both.

For gestures, [@Erazo:2015d6c] describe the temporal structure of a gesture in terms of _gesture units_ and _gesture phrases_. A gesture unit is defined as the time between the start and the end of limb movements, and may contain one or more gesture phrases. A gesture phrase in turn can be a _stroke phrase_, or a _hold phrase_. In addition, we include _action_, which can consist either of a gesture unit, or a _movement_ that is not a gesture. We can summarise these concepts as:

\begin{align}
\begin{split}
    \text{action} & = \text{gesture unit}\,\,|\,\,\textcolor{green}{\text{movement}}\\
    \text{gesture unit} & = \{\text{gesture phrases}\} + [\text{Retraction}]\\
    \text{gesture phrase} & = \textcolor{yellow}{\text{hold phrase}}\,\,|\,\, \textcolor{red}{\text{stroke phrase}}\\
    \textcolor{yellow}{\text{hold phrase}} & = [\text{preparation}] + \text{hold}\\
    \textcolor{red}{\text{stroke phrase}} & = [\text{preparation}] + [\text{pre-stroke hold}] + \text{stroke} + [\text{post-stroke hold}].
    \label{eq:PhraseGrammar}
\end{split}
\end{align}

Here, curly brackets denote one or multiple elements, square brackets optional elements, and elements without brackets are mandatory.


| Operator | Description | Time/s |
|:--|:--|:--|
| \cellcolor{blue!10}\textbf{M}ental | Mentally preparing a physical action. | $1.35$ |
| \cellcolor{blue!10}\textbf{R}(t) | Response time of the system. | $t$ |
| \cellcolor{blue!10}\textbf{K}eystroke | Pressing a key, including modifiers. | $0.2$ avg. |
| \cellcolor{green!10}\textbf{P}ointing | Pointing to a target, subject to Fitts's Law (or extensions).  | $1.1$ \citep{Murata:2001ebc,Erazo:2015d6c} |
| \cellcolor{green!10}\textbf{Pr}eparation | Preparation of the execution of movements. | t |
| \cellcolor{green!10}\textbf{W}alk | Walking to reach a target area. | t |
| \cellcolor{green!10}\textbf{Re}traction | Retracting an arm after the execution of a movement. | t |
| \cellcolor{yellow!10}\textbf{H}olding | Holding a position in 3D space with the hand. |  t |
| \cellcolor{yellow!10}\textbf{T}apping | Tapping in 3D space. | t |
| \cellcolor{yellow!10}\textbf{D}rawing | Drawing a shape in 3D space. | t |
| \cellcolor{yellow!10}\textbf{S}wiping | Performing a swipe gesture. | t |
| \cellcolor{yellow!10}\textbf{G}ripping | Gripping an object. | t |
| \cellcolor{yellow!10}\textbf{R}eleasing | Releasing an object. | t |

Table: The operators in our extended model, colour-coded according to \ref{eq:PhraseGrammar}. {#tbl:VRKLMOperators}




