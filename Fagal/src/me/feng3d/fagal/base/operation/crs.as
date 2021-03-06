package me.feng3d.fagal.base.operation
{
	import me.feng3d.fagal.IField;
	import me.feng3d.fagal.base.append;

	/**
	 * crs:两个寄存器间的叉积
	 * <br/>
	 * destination.x=source1.y*source2.z-source1.z*source2.y
	 * <br/>
	 * destination.y=source1.z*source2.x-source1.x*source2.z
	 * <br/>
	 * destination.z=source1.x*source2.y-source1.y*source2.x
	 * @author warden_feng 2014-10-22
	 */
	public function crs(destination:IField, source1:IField, source2:IField):void
	{
		var code:String = "crs " + destination + ", " + source1 + ", " + source2;
		append(code);
	}
}
