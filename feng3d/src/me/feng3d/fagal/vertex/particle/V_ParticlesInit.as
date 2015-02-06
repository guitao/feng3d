package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 粒子初始化顶点渲染程序
	 * @author warden_feng 2014-12-26
	 */
	public class V_ParticlesInit extends FagalVertexMethod
	{
		[Register(regName = "position_va_3", regType = "in", description = "顶点坐标数据")]
		public var positionReg:Register;

		[Register(regName = "animatedPosition_vt_4", regType = "out", description = "动画后的顶点坐标数据")]
		public var animatedPosition:Register;

		[Register(regName = "particleCommon_vc_vector", regType = "uniform", description = "粒子常数数据[0,1,2,0]")]
		public var particleCommon:Register;

		[Register(regName = "positionTemp_vt_4", regType = "out", description = "偏移坐标临时寄存器")]
		public var positionTemp:Register;

		override public function runFunc():void
		{
			comment("初始化粒子");
			mov(animatedPosition, positionReg); //坐标赋值
			mov(positionTemp.xyz, particleCommon.x); //初始化偏移位置0
		}
	}
}