import { Project } from '@langri-sha/projen-project'

const project = new Project({
  name: 'docker-keybase',
  package: {
    authorEmail: 'filip.dupanovic@gmail.com',
    authorName: 'Filip Dupanović',
    authorOrganization: false,
    authorUrl: 'https://langri-sha.com',
    bugsUrl: 'https://github.com/langri-sha/docker-keybase/issues',
    homepage: 'https://github.com/langri-sha/docker-keybase/#readme',
    minNodeVersion: '24.16.0',
    repository: 'langri-sha/docker-keybase',
    type: 'module',

    entrypoint: '',
    npmProvenance: false,

    copyrightYear: '2017',
    license: 'MIT',
    licensed: true,

    devDeps: ['@langri-sha/prettier@^0.4.6', 'prettier@3.9.6'],
    peerDependencyOptions: {
      pinnedDevDependency: false,
    },
  },
  codeowners: {
    '*': '@langri-sha',
  },
  editorConfig: {},
  lintSynthesized: {},
  pnpmWorkspace: {
    minimumReleaseAgeExclude: ['@langri-sha/*'],
    allowBuilds: {
      esbuild: false,
    },
  },
  prettier: {},
  renovate: {
    packageRules: [
      {
        description: 'Packages published from the langri-sha/projen monorepo',
        groupName: 'langri-sha projen toolchain',
        groupSlug: 'langri-sha-projen',
        matchSourceUrls: ['https://github.com/langri-sha/projen'],
      },
      {
        description: 'Install our own packages without waiting them out',
        matchPackageNames: ['@langri-sha/**'],
        minimumReleaseAge: null,
      },
      {
        description:
          'Install our own GitHub Actions and Terraform modules without waiting them out',
        matchPackageNames: ['langri-sha/**'],
        minimumReleaseAge: null,
      },
    ],
  },
  typeScriptConfig: {},
})

project.package?.addEngine('pnpm', '>= 11.0.0')
project.package?.addField('packageManager', 'pnpm@11.25.0')
project.package?.addField('private', true)

project.tryFindObjectFile('package.json')?.addDeletionOverride('pnpm')

project.synth()
