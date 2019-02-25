# Interface Efficiency

The efficiency of Human-Computer Interfaces can be measured in various ways, such as watching different types of users — unexperienced vs. experienced — use a specific interface and evaluating their actions subjectively, or by trying to come up with a mathematical model of how the user will interact a specific interface. In this chapter we are going to explore the latter possibility, in the form of an extension of the GOMS model:

## The GOMS Model for Quantifying Interface Efficiency

A widely used model for quantification the efficiency of an interface is a model based on defining \textbf{G}oals, a set of \textbf{O}perators used as instruments, a set of \textbf{M}ethods to achieve the defined Goals, and a definition of \textbf{S}election rules how to discern competing methods, in short _GOMS_. The GOMS model, or it's original version, _CMN-GOMS_, the  was introduced in 1980 by Card, Moran, and Newell [@Card:1980kl] and can help to predict the time taken by an experienced user to perform a given task. It soon turned out it was relatively difficult to build a CMN-GOMS -based predictor, and the authors published a highly simplified version of it, the _Keystroke-Level Model_ (KLM) [@Card:1980kl].

The main benefit of the original KLM-GOMS model is that it is simple and easy to evaluate, and — despite making assumptions about the average time taken for different parts of a task's execution — it is quite accurate in addition. Since its inception has been widely used, e.g. for \TODO{add example papers}. The major downsides of the model is not taking other aspects of the user's performance into consideration: already the original authors acknowledge not taking into account factors like fatigue, learning, or errors made during execution [@Card:1980kl]. As mentioned above, the model also assumes an experienced user, and as such cannot be applied to the unskilled user.

Since the development of the original model, more derivatives were developed such as, 

* _CPM-GOMS_ [@John:1995cp], extending the original GOMS model to parallel tasks, 
* _Codein_ [@Christou:2012b12], a new notation for GOMS which extends to reality-based interfaces, or
* the _Touch-Level Model_ (TLM) [@Rice:2014341], which not only extends the use of KLM-GOMS to today's ubiquitous touch-enabled devices, but also introduces new operators, e.g. for taps, gestures, or real-world distractions.

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
| \textbf{K}eystroke | Pressing a key, including modifiers. | $0.08 - 1.20$ |
| \textbf{P}ointing | Pointing to a target, subject to Fitt's Law | $1.1$ |
| \textbf{H}oming | Homing the hands on an input device. | $0.4$ |
| \textbf{D}rawing | Drawing $n$ line segments of length $l$ | $0.9n + 0.16l$ |
| \textbf{M}ental | Mentally preparing a physical action. | $1.35$ |
| \textbf{R}esponse | Time $t$ the user has to wait for the system to respond. | t |

Table: Execution times for the KLM-GOMS operators. {#tbl:GOMSExecutionTimes}

[^FittsNote]: The given expression only applies to 1D mouse movements. The constants $a$ and $b$ of the general form of Fitts's Law, $T = a + b \cdot \ln\left(\frac{d}{s}+0.5\right)$ have to be determined experimentally for other cases.

After putting together the operators for the task under evaluation, a set of heuristics needs to be applied for distributing the Mental operators correctly (following [@Card:1980kl] and [@Raskin:2000thi]):

1. Place Ms in front of all Ks that are not part of an argument. Place Ms in front of all Ps that select commands, but not arguments.
2. Delete an M if it is _fully anticipated_, e.g. if a P is followed by a K for e.g. clicking a button, there will be no M in between. (PMK becomes PK).
3. If a string of MKs belongs to a _cognitive unit_, delete all Ms but the first (such as when typing the name of a command, or any of its arguments).
4. If a K is a redundant delimiter, e.g. terminating a command immediately following the terminator of its argument, delete the M before it.
5. If a K terminates a _constant string_, such as a command name, delete the M before it. If the string is not constant, such as in an argument, do not delete the M.
6. Delete any Ms that overlap an R.

While these six heuristics may seem arbitrary at first glance, they have a deeper rooting in cognitive psychology — _chunking_: Performing an additional keystroke action (like pressing the \keys{\return} key), e.g. to confirm a selection or end a command, does not cost the user additional mental effort, and as usage proficiency grows, will be assimilated into entering the command. This "package" is called a chunk. A user therefore does not mentally prepare for just the next operation, but for a chunk of them [@Card:1980kl].

### An Example KLM-GOMS Calculation

## An Extension of GOMS for Virtual Reality

## Measuring Interface Efficiency



