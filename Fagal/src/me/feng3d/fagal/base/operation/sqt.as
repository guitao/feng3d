package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * destination=sqrt(source):一个寄存器的平方根，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function sqt(destination:IField, source1:IField):void
	{
		var code:String = "sqt " + destination + ", " + source1;
		append(code);
	}
}
