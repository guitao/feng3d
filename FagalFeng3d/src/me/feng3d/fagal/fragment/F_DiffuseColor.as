package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 漫反射材质颜色
	 * @author warden_feng 2014-11-6
	 */
	public function F_DiffuseColor(diffColorReg:Register, mdiffReg:Register):void
	{
		//漫射输入静态数据 
		mov(mdiffReg, diffColorReg);
	}
}
