**Note 1:** This program only provides some codes to provide research ideas and result verification. No commercial use is allowed without permission.

**Note 2: **Due to data security problems, the data name has been modified, and the parameter name part in the data has been deleted.

# Lossless compression and encryption of logging data

In data processing, there are few compression encryption algorithms for a certain type of data. In order to meet the needs of industry in this regard, we have developed a compression and encryption scheme for logging data.  Its highlights include effective data extraction, low bits separation coding and nested chaotic system. First, the effective data is extracted and represented by data with additional location information. Second, the number of unequal values of effective data is reduced by data gradient, symbol extraction and low bit separation, and the obtained data is Huffman encoded. Finally, all relevant data is converted to binary and merged, and binary confusion encryption is executed. Simulation experiments and performance analysis show that our scheme has a great breakthrough in compression ratio while ensuring compression efficiency, which is 5-8.5 times of the mainstream compression scheme ZIP. The idea of our scheme is suitable for all files in the form of logging data, which can compress data to a large extent and ensure data security.

## Scope of application

Based on extensive observations and experiments, as shown in Figure 1, the logging data is divided into three parts: parameter name, location data, and parameter data. Our solution is applicable to all data stored in this way.

![The structure of logging data](/img/loggingdata.png "The structure of logging data")

## The whole scheme of logging data compression and encryption

It can be described as follows:

1. The first step of this scheme is to extract the parameter names, use the record start position, step length and number of records to represent the position data, and use the effective data start position, number of data and effective data values to represent the parameter data.

2. Performing the second gradient on the effective data value $D$, we can obtain the gradient data $D_{diff}$. $D_{diff}$ is separated into sign part $D_{sign}$ and absolute value part $D_{abs}$. We magnify $D_{abs}$ to integer $D_{int}$ and record the magnification $10^{\gamma}$.
3. We separate the lower bits of $D_{int}$ in turn until the number of unequal values in the value represented by the remaining higher bits is not greater than the threshold value $\delta$, and store the separated low bits $D_{bit}$ separately. The high bits are processed using Huffman coding to obtain encoding $D_{enco}$ and encoding dictionary $D_{dict}$.
4. All relevant information are converted to binary and merged. The key is used as an input parameter to generate a random sequence by nested chaotic mapping, according to which the compressed data is shuffled and randomly inverted.

![The whole scheme of logging data compression and encryption](/img/scheme.png "The whole scheme of logging data compression and encryption")

## Document description

`W*.txt`: logging data.

`CompressionAndEncrypt.m`: main function. Used for compression and encryption of logging data.

`chaossys8.m`: chaotic mapping function. Used to generate random sequences.