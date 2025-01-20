function initTimeChart(elementId, data) {
    const chartDom = document.getElementById(elementId);
    const style = window.getComputedStyle(chartDom);
    const chart = echarts.init(chartDom);

    const option = {
        tooltip: {
            trigger: "axis",
            formatter: function (params) {
                params = params[0];
                var date = new Date(params.value[0]);
                return (
                    date.getDate() +
                    "/" +
                    (date.getMonth() + 1) +
                    "/" +
                    date.getFullYear() +
                    " " +
                    date.getHours() +
                    ":" +
                    date.getMinutes() +
                    ":" +
                    date.getSeconds() +
                    " : " +
                    params.value[1] +
                    "$"
                );
            },
            axisPointer: {
                animation: false,
            },
        },
        grid: {
            left: 25,
            right: 25,
            bottom: 25,
            top: 25,
        },
        xAxis: {
            type: "time",
            splitLine: {
                show: false,
            },
        },
        yAxis: {
            type: "value",
            splitLine: {
                show: false,
            },
        },
        series: [
            {
                lineStyle: {
                    color: style.getPropertyValue('--primary'),
                },
                itemStyle: {
                    color: style.getPropertyValue('--primary'),
                },
                data,
                type: "line",
            },
        ],
    };

    chart.setOption(option);
}

export default { initTimeChart };
