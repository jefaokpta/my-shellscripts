const { execSync } = require('child_process');
const { log } = require('console');

const controlNumbers = [] 

const dynos = JSON.parse(execSync('heroku apps --json'))
log(`Found ${dynos.length} dynos`)


dynos.forEach((dyno) => {
    log(`Checking ${dyno.name} ID: ${dyno.id} ...`)
    const dynoConfig = JSON.parse(execSync(`heroku config -a ${dyno.name} --json`))
    controlNumbers.push(dynoConfig.CONTROL_NUMBER)
    log(dynoConfig)
})

const hasDuplicates = (array) => {
    return (new Set(array)).size !== array.length;
}

const showDuplicates = (array) => {
    return array.filter((item, index) => array.indexOf(item) !== index)
}

if (hasDuplicates(controlNumbers)) {
    log('Tem control numbers duplicados 😱')
    log('Mostrando control numbers duplicados:')
    log(showDuplicates(controlNumbers))
    process.exit(1)
}

log('Sem control numbers duplicados 👍🏻')


/* 
exemplo de app config
{
  CONTROL_NUMBER: '563023',
  NODE_ENV: 'production',
  URL_BASE: 'https://endereco-da-api.com',
  WIP_API_URL: 'https://coral-aocean.app'
}

exemplo de app
{
    acm: false,
    archived_at: null,
    buildpack_provided_description: 'Node.js',
    build_stack: { id: '5fc4e202-3efa-40a9-9789-3e', name: 'heroku-22' },
    created_at: '2024-01-31T19:12:41Z',
    id: 'c29324ca-52ce-44c',
    git_url: 'https://git.he',
    maintenance: false,
    name: 'cryptic-wildwood-8',
    region: { id: '59accabd-516d-4f0e-83', name: 'us' },
    organization: null,
    team: null,
    space: null,
    internal_routing: null,
    released_at: '2024-01-31T19:13:13Z',
    repo_size: null,
    slug_size: 67220755,
    stack: { id: '5fc4e202-3efa-40a9-9789-', name: 'heroku-22' },
    updated_at: '2024-01-31T19:13:13Z',
    web_url: 'https://cryptic-wildwood-10f9b.herokuapp.com/'
  },
*/