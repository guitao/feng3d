package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;
	
	/**
	 * destination=pow(source1 ，source2):source1的source2次冥，分量形式
	 * @author warden_feng 2014-10-22
	 */
	public function pow(destination:IField, source1:IField, source2:IField):void
	{
		var code:String = "pow " + destination + ", " + source1 + ", " + source2;
		append(code);
	}
}