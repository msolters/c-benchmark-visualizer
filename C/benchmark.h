/*
 * benchmark.h
 *
 * Created: 9/10/2015 5:56:28 PM
 *  Author: Mark Solters
 */ 


#ifndef BENCHMARK_H_
#define BENCHMARK_H_

#define BENCHMARKING true

void benchmark(char *msg)
{
	if (BENCHMARKING)
	{
		printf("%c%s%c", 0x02, msg, 0x03);
	}
}

void benchmark_sync()
{
	benchmark("init");
}

#endif /* BENCHMARK_H_ */
