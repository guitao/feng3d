package me.feng3d.fagal.vertex
{
	import me.feng3d.fagal.context3dDataIds.Context3DBufferTypeID;
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.base.requestRegister;
	import me.feng3d.fagal.base.operation.mov;

	/**
	 * 世界坐标输出函数
	 * @author warden_feng 2014-11-7
	 */
	public function V_WorldPositionOut(positionSceneReg:Register):void
	{
		//世界坐标变量
		var globalPosVaryReg:Register = requestRegister(Context3DBufferTypeID.GLOBALPOS_V);
		
		mov(globalPosVaryReg, positionSceneReg);
	}
}
