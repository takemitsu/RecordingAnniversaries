
mainControllers.filter 'JDate', ->
  return (input, only_wayear) ->

    if not input
        return ''

    if input.length isnt 10
        return ''

    dates = input.split("-");
    if dates.length isnt 3
        return ''

    date = parseInt(dates.join(""))
    if not date
        return ''

    if dates[0] > 2099
        return ''
    if dates[1] > 12 || dates[1] is "00"
        return ''
    if dates[2] > 31 || dates[2] is "00"
        return

    if date >= 19890108
        gengo = '平成'
        wayear = dates[0] - 1988
    else if date >= 19261225
        gengo = '昭和'
        wayear = dates[0] - 1925
    else if date >= 19120730
        gengo = '大正'
        wayear = dates[0] - 1911
    else if date >= 18680125
        gengo = '明治'
        wayear = dates[0] - 1867
    else
        return ''

    if wayear is 1
        wayear = '元'

    if only_wayear is 1
        return gengo + wayear + '年'

    return gengo + wayear + '年' + dates[1] + '月' + dates[2] + '日'
