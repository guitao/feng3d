package me.feng3d.fagal.fragment
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.removeTemp;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 最终颜色输出函数
	 * @author warden_feng 2014-11-7
	 */
	public function F_FinalOut(finalColorReg:Register, out:Register):void
	{
		mov(out, finalColorReg);

		removeTemp(finalColorReg);
	}
}
