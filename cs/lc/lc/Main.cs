using System;

namespace lc
{
	class MainClass
	{
		private static Func<dynamic, Func<dynamic, dynamic>> zero = f => x => x;
		//强类型的语言实现lambda calculus太费劲了，变量类型声明如此之长
		private static Action<Func<Func<dynamic, dynamic>, Func<dynamic, dynamic>>> print = expr => {				
			Console.WriteLine (expr (n => n + 1) (0));
		};
		private	static Func<dynamic, Func<dynamic, Func<dynamic, dynamic>>> succ = n => f => x => f (n (f) (x));

		public static void Main (string[] args)
		{
			print (zero);
			print (succ (zero));
			print (succ (succ (zero)));
			Console.WriteLine ("Hello World!");
		}
	}
}
