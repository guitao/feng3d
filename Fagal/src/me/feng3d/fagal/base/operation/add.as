package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;
	
	/**
	 * destination=source1+source2:两个寄存器相加，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function add(destination:IField, source1:IField, source2:IField):void
	{
		var code:String = "add " + destination + ", " + source1 + ", " + source2;
		append(code);
	}
}